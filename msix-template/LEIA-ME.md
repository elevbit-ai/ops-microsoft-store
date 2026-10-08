# Template MSIX — ferramentas Windows (OpS/Elevbit)

Empacota um app de desktop em `.msix` para a Microsoft Store.

## Passos
1. **Tenha um `.exe` de entrada:**
   - Python → `pyinstaller --onefile --noconsole app.py` (sai em `dist/app.exe`).
   - `.exe` já compilado → use direto.
   - **Scripts (`.bat`/`.ps1`/`.hta`, como o JP TERMINAL)** → o MSIX precisa de um executável de entrada. Opções:
     - criar um pequeno launcher `.exe` (C/C#/Go) que chame `powershell.exe -File seu-script.ps1`;
     - ou converter o app para um `.exe` (p.ex. empacotar o script com uma ferramenta tipo PS2EXE para PowerShell).
2. **Edite `AppxManifest.xml`:** troque `Identity Name`, `Publisher` e `Executable` pelos valores reais (os de identidade vêm do Partner Center após reservar o nome — veja o guia principal).
3. **Coloque nesta pasta** o `.exe` + arquivos do app e a pasta `Assets\` (tiles). Os tiles de exemplo (JP TERMINAL) já estão em `Assets\`.
4. **Gere o pacote:** `powershell -ExecutionPolicy Bypass -File build-msix.ps1`
   - para testar localmente: `... build-msix.ps1 -Assinar` (cria um certificado de teste e assina).
5. **Suba** o `.msix` no Partner Center.

## Requisitos
- **Windows 10/11 SDK** (fornece `makeappx.exe` e `signtool.exe`). Instale pelo Visual Studio Installer ou `winget install Microsoft.WindowsSDK`.

> Para a Store você **não** precisa assinar o pacote — a Microsoft reassina com o seu identity. A assinatura só é necessária para instalar/testar fora da Store.

Autor: Joaquim Pedro de Morais Filho — j360074@hotmail.com
