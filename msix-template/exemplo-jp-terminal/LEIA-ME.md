# Exemplo MSIX pronto — JP TERMINAL

Pacote **montado e pronto para empacotar**. O launcher (`JPTerminal.exe`, compilado
em C#) abre o `jpterm-console.ps1` (o console real do JP TERMINAL) de dentro do pacote.

## Gerar o .msix
Com o **Windows 10/11 SDK** instalado (fornece `makeappx.exe`):

```
makeappx pack /d . /p JP-TERMINAL.msix /o
```

(ou use o `build-msix.ps1` da pasta acima). Para **testar** localmente, assine com um
certificado cujo CN seja igual ao `Publisher` do `AppxManifest.xml`.

## Para a Microsoft Store
Troque no `AppxManifest.xml` os campos `Identity Name` e `Publisher` pelos valores do
**Partner Center** (Product identity) e gere o pacote de novo. A Store reassina.

Obs.: o `JPTerminal.cs` é só o código-fonte do launcher; não precisa ir no pacote final.

Autor: Joaquim Pedro de Morais Filho — j360074@hotmail.com
