# build-msix.ps1 - empacota a pasta atual num .msix
# Criado por Joaquim Pedro de Morais Filho - j360074@hotmail.com
#
# Uso:
#   1) Ajuste AppxManifest.xml (Identity/Publisher do Partner Center, Executable).
#   2) Coloque nesta pasta o(s) arquivo(s) do app (o .exe de entrada + dependencias)
#      e a pasta Assets\ (tiles).
#   3) Rode:  powershell -ExecutionPolicy Bypass -File build-msix.ps1
#
# Para a STORE voce NAO precisa assinar (a Microsoft reassina).
# Para TESTAR localmente, use -Assinar para criar um cert proprio e assinar.

param(
  [string]$Saida = "pacote.msix",
  [switch]$Assinar
)

function Achar($nome){
  $base = "C:\Program Files (x86)\Windows Kits\10\bin"
  if(!(Test-Path $base)){ return $null }
  Get-ChildItem $base -Recurse -Filter $nome -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match '\\x64\\' } |
    Sort-Object FullName -Descending | Select-Object -First 1 -Expand FullName
}

$makeappx = Achar 'makeappx.exe'
$signtool = Achar 'signtool.exe'
if(-not $makeappx){
  Write-Host "makeappx.exe nao encontrado. Instale o 'Windows 10/11 SDK' (via Visual Studio Installer ou winget: Microsoft.WindowsSDK)." -ForegroundColor Yellow
  return
}

$pasta = (Get-Location).Path
Write-Host "Empacotando '$pasta' -> $Saida"
& $makeappx pack /d $pasta /p $Saida /o
if($LASTEXITCODE -ne 0){ Write-Host "Falha no makeappx." -ForegroundColor Red; return }
Write-Host "MSIX gerado: $Saida" -ForegroundColor Green

if($Assinar){
  if(-not $signtool){ Write-Host "signtool.exe nao encontrado (SDK)." -ForegroundColor Yellow; return }
  $pfx = "jp-teste.pfx"; $senha = "teste123"
  $cert = New-SelfSignedCertificate -Type Custom -Subject "CN=Joaquim Pedro de Morais Filho" `
          -KeyUsage DigitalSignature -FriendlyName "JP OpS Teste" -CertStoreLocation "Cert:\CurrentUser\My" `
          -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3","2.5.29.19={text}")
  $pw = ConvertTo-SecureString -String $senha -Force -AsPlainText
  Export-PfxCertificate -Cert $cert -FilePath $pfx -Password $pw | Out-Null
  & $signtool sign /fd SHA256 /a /f $pfx /p $senha $Saida
  Write-Host "Assinado para teste local. (Identity Publisher do manifesto deve bater com CN do cert.)" -ForegroundColor Green
  Write-Host "Para instalar e testar: dois cliques no .msix ou Add-AppxPackage .\$Saida" -ForegroundColor Cyan
}
