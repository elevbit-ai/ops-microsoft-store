# ============================================================
#  JP TERMINAL  -  console real estilo 1995
#  Criado por Joaquim Pedro de Morais Filho  -  j360074@hotmail.com
#  E um PowerShell DE VERDADE: todos os comandos funcionam.
#  Este script so deixa o terminal com a cara certa e com as
#  funcoes de analise (anexar / jpanalisar / jphex / jpstrings).
# ============================================================

# ---- aparencia estilo 1995 (fosforo verde) ----
try{
  $ui = $Host.UI.RawUI
  $ui.WindowTitle    = 'JP TERMINAL'
  $ui.BackgroundColor= 'Black'
  $ui.ForegroundColor= 'Green'
  try{
    $sz = $ui.BufferSize; $sz.Width = 110; $sz.Height = 3000; $ui.BufferSize = $sz
    $win = $ui.WindowSize; $win.Width = 110; $win.Height = 34; $ui.WindowSize = $win
  }catch{}
  Clear-Host
}catch{}

# ---- hexdump dos primeiros N bytes ----
function jphex { param([string]$Path,[int]$Count=256)
  try{ $fs=[IO.File]::OpenRead($Path) }catch{ Write-Host ('Erro ao abrir: '+$Path) -ForegroundColor Red; return }
  $n=[int][Math]::Min([long]$Count,$fs.Length)
  $b=New-Object byte[] $n; [void]$fs.Read($b,0,$n); $fs.Close()
  for($o=0;$o -lt $n;$o+=16){
    $hex=''; $asc=''
    for($i=0;$i -lt 16;$i++){
      if($o+$i -lt $n){ $c=$b[$o+$i]; $hex+=('{0:X2} ' -f $c); if($c -ge 32 -and $c -lt 127){$asc+=[char]$c}else{$asc+='.'} } else { $hex+='   ' }
    }
    ('{0:X8}  {1} |{2}|' -f $o,$hex,$asc)
  }
}

# ---- strings legiveis dentro de um arquivo ----
function jpstrings { param([string]$Path,[int]$Min=5)
  try{ $fs=[IO.File]::OpenRead($Path) }catch{ Write-Host ('Erro ao abrir: '+$Path) -ForegroundColor Red; return }
  $n=[int][Math]::Min([long]2097152,$fs.Length)
  $b=New-Object byte[] $n; [void]$fs.Read($b,0,$n); $fs.Close()
  $cur=''; $cnt=0
  for($i=0;$i -lt $n;$i++){ $x=$b[$i]
    if($x -ge 32 -and $x -lt 127){ $cur+=[char]$x } else { if($cur.Length -ge $Min){ $cur; $cnt++; if($cnt -ge 400){break} }; $cur='' }
  }
  if($cur.Length -ge $Min){ $cur }
}

# ---- analise completa de arquivo/foto ----
function jpanalisar { param([string]$Path)
  if(!(Test-Path -LiteralPath $Path)){ Write-Host ('Arquivo nao encontrado: '+$Path) -ForegroundColor Red; return }
  $it = Get-Item -LiteralPath $Path
  if($it.PSIsContainer){ Write-Host ('E uma pasta, nao um arquivo: '+$Path) -ForegroundColor Red; return }
  $fs=[IO.File]::OpenRead($it.FullName)
  $m=[int][Math]::Min([long]16,$it.Length); $b=New-Object byte[] $m; [void]$fs.Read($b,0,$m); $fs.Close()
  function BB($i){ if($i -lt $b.Length){ $b[$i] } else { -1 } }
  $tipo='Binario / nao identificado'
  if((BB 0) -eq 0x89 -and (BB 1) -eq 0x50){ $tipo='Imagem PNG' }
  elseif((BB 0) -eq 0xFF -and (BB 1) -eq 0xD8){ $tipo='Imagem JPEG' }
  elseif((BB 0) -eq 0x47 -and (BB 1) -eq 0x49 -and (BB 2) -eq 0x46){ $tipo='Imagem GIF' }
  elseif((BB 0) -eq 0x42 -and (BB 1) -eq 0x4D){ $tipo='Imagem BMP' }
  elseif((BB 0) -eq 0x25 -and (BB 1) -eq 0x50 -and (BB 2) -eq 0x44 -and (BB 3) -eq 0x46){ $tipo='Documento PDF' }
  elseif((BB 0) -eq 0x50 -and (BB 1) -eq 0x4B){ $tipo='ZIP / DOCX / XLSX / APK' }
  elseif((BB 0) -eq 0x52 -and (BB 1) -eq 0x61 -and (BB 2) -eq 0x72){ $tipo='Arquivo RAR' }
  elseif((BB 0) -eq 0x37 -and (BB 1) -eq 0x7A){ $tipo='Arquivo 7-Zip' }
  elseif((BB 0) -eq 0x4D -and (BB 1) -eq 0x5A){ $tipo='Executavel Windows (PE / MZ)' }
  elseif((BB 0) -eq 0x7F -and (BB 1) -eq 0x45 -and (BB 2) -eq 0x4C -and (BB 3) -eq 0x46){ $tipo='Executavel Linux (ELF)' }
  elseif((BB 0) -eq 0x49 -and (BB 1) -eq 0x44 -and (BB 2) -eq 0x33){ $tipo='Audio MP3' }
  elseif((BB 0) -eq 0x1F -and (BB 1) -eq 0x8B){ $tipo='Arquivo GZIP' }
  elseif((BB 0) -eq 0x53 -and (BB 1) -eq 0x51 -and (BB 2) -eq 0x4C){ $tipo='Banco de dados SQLite' }
  $sha=(Get-FileHash -LiteralPath $it.FullName -Algorithm SHA256).Hash
  $md5=(Get-FileHash -LiteralPath $it.FullName -Algorithm MD5).Hash
  Write-Host ''
  Write-Host '==============================================================' -ForegroundColor Green
  Write-Host ' ANALISE DE ARQUIVO' -ForegroundColor White
  Write-Host '==============================================================' -ForegroundColor Green
  ' Nome .......: '+$it.Name
  ' Caminho ....: '+$it.FullName
  ' Tipo real ..: '+$tipo
  ' Tamanho ....: '+('{0:N0}' -f $it.Length)+' bytes'
  ' Criado .....: '+$it.CreationTime
  ' Modificado .: '+$it.LastWriteTime
  ' Atributos ..: '+$it.Attributes
  ' SHA-256 ....: '+$sha
  ' MD5 ........: '+$md5
  if($tipo -like 'Imagem*'){
    try{ Add-Type -AssemblyName System.Drawing -ErrorAction Stop
      $img=[System.Drawing.Image]::FromFile($it.FullName)
      ' Dimensoes ..: '+$img.Width+' x '+$img.Height+' px'
      $map=@{271='Fabricante';272='Modelo';305='Software';306='Data arq.';36867='Data foto'}
      foreach($id in $map.Keys){ $pi=$img.PropertyItems | Where-Object { $_.Id -eq $id } | Select-Object -First 1
        if($pi){ $v=[Text.Encoding]::ASCII.GetString($pi.Value); $v=$v.Trim([char]0).Trim(); if($v){ ' '+($map[$id]).PadRight(11)+' : '+$v } } }
      $gps=$img.PropertyItems | Where-Object { $_.Id -eq 2 -or $_.Id -eq 4 }
      if($gps){ Write-Host ' GPS ........: a FOTO contem coordenadas de localizacao (EXIF)' -ForegroundColor Yellow }
      $img.Dispose()
    }catch{}
  }
  Write-Host '-------------------------------------------------- HEXDUMP (128 bytes)' -ForegroundColor DarkGreen
  jphex -Path $it.FullName -Count 128
  Write-Host '--------------------------------------------------------------' -ForegroundColor DarkGreen
  Write-Host "Mais: jphex 'caminho' 256  |  jpstrings 'caminho'  |  jpanalisar 'caminho'" -ForegroundColor DarkGreen
}

# ---- anexar: seletor nativo + analise ----
function anexar {
  Add-Type -AssemblyName System.Windows.Forms
  $f = New-Object System.Windows.Forms.OpenFileDialog
  $f.Multiselect = $true
  $f.Title = 'JP TERMINAL - selecione arquivo(s) para analisar'
  $f.Filter = 'Todos os arquivos (*.*)|*.*'
  if($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
    foreach($p in $f.FileNames){ jpanalisar -Path $p }
  } else { Write-Host 'Nenhum arquivo selecionado.' -ForegroundColor DarkGreen }
}
Set-Alias -Name ANEXAR -Value anexar

# ---- cor do fosforo ----
function cor { param([string]$c='verde')
  $map=@{ 'verde'='Green'; 'ambar'='DarkYellow'; 'amarelo'='Yellow'; 'branco'='Gray'; 'ciano'='Cyan' }
  $v = $map[$c.ToLower()]; if(!$v){ $v='Green' }
  try{ $Host.UI.RawUI.ForegroundColor=$v }catch{}
  Write-Host ('Fosforo: '+$c) -ForegroundColor $v
}

# ---- creditos ----
function sobre {
  Write-Host ''
  Write-Host '   JP TERMINAL  v3.0  (console real)' -ForegroundColor White
  Write-Host '   ------------------------------------------' -ForegroundColor Green
  Write-Host '   Criado por: Joaquim Pedro de Morais Filho'
  Write-Host '               j360074@hotmail.com'
  Write-Host '   ------------------------------------------' -ForegroundColor Green
  Write-Host '   Terminal leve estilo 1995. PowerShell real'
  Write-Host '   + analise local de fotos e arquivos.'
  Write-Host '   (C) 1995-2026 - Todos os direitos reservados'
  Write-Host ''
}

# ---- ajuda ----
function ajuda {
  Write-Host ''
  Write-Host ' JP TERMINAL - este e um PowerShell DE VERDADE.' -ForegroundColor White
  Write-Host ' Use qualquer comando: dir, cd, ipconfig, ping, cls, Get-Process...'
  Write-Host ''
  Write-Host ' Extras:' -ForegroundColor White
  Write-Host "   anexar                abre seletor e analisa arquivo(s)/foto(s)"
  Write-Host "   jpanalisar 'caminho'  tipo real, SHA-256, MD5, EXIF/GPS, hexdump"
  Write-Host "   jphex 'caminho' 256   hexdump dos primeiros bytes"
  Write-Host "   jpstrings 'caminho'   textos legiveis dentro do arquivo"
  Write-Host "   cor verde|ambar|branco|amarelo|ciano   muda o fosforo"
  Write-Host "   sobre                 creditos      |   ajuda   esta tela"
  Write-Host "   cls                   limpa a tela  |   exit    fecha"
  Write-Host ''
  Write-Host ' Copiar/colar: selecione com o mouse e Enter copia; botao direito cola' -ForegroundColor DarkGreen
  Write-Host ' (ou Ctrl+C / Ctrl+V). Arraste um arquivo para a janela e o CAMINHO e colado.' -ForegroundColor DarkGreen
  Write-Host ''
}

# ---- prompt estilo JP ----
function global:prompt {
  Write-Host ('JP ' + (Get-Location).Path + '>') -NoNewline -ForegroundColor Green
  return ' '
}

# ---- banner de abertura ----
Write-Host ''
Write-Host '     ##   #####      ####### ####### #####  #     # # #     #   ##   #' -ForegroundColor Green
Write-Host '     ##   ##   #        ##   ##      ##   # ##   ## # ##    #  #  #  #' -ForegroundColor Green
Write-Host '##   ##   ######        ##   #####   ######  ## ##  # # #   # ###### #' -ForegroundColor Green
Write-Host '##   ##   ##            ##   ##      ##   #  #   #  # #  #  # #    #  #' -ForegroundColor Green
Write-Host ' #####    ##            ##   ####### ##   #  #   #  # #   ### #    #  ######' -ForegroundColor Green
Write-Host ''
Write-Host ' JP TERMINAL v3.0 - console real com PowerShell' -ForegroundColor White
Write-Host ' Criado por Joaquim Pedro de Morais Filho - j360074@hotmail.com'
Write-Host ' (C) 1995-2026   Memoria convencional: 640K OK'
Write-Host ''
Write-Host ' Este e um terminal REAL: todos os comandos funcionam.' -ForegroundColor DarkGreen
Write-Host ' Digite  ajuda  para ver tudo, ou  anexar  para analisar uma foto/arquivo.' -ForegroundColor DarkGreen
Write-Host ''
