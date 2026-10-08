# 🏪 Guia de publicação na Microsoft Store — OpS / Elevbit

Guia prático para publicar os apps **Windows** e **web (PWA)** de Joaquim Pedro de Morais Filho na **Microsoft Store**. Tudo que dá para automatizar já está pronto neste repositório; o que **exige a sua conta** está marcado com 🔑.

> **Importante — o que a Store aceita e o que NÃO aceita**
> - ✅ **PWA** (web apps) e **apps Windows** (MSIX ou instalador EXE/MSI).
> - ❌ **Android (APK/AAB) não entra na Microsoft Store.** Os apps Android (JP Teleprompter, JP Secure Lock, OpS Bank Crypto, OpS Crypt Android, usacomment-ops, etc.) vão para a **Google Play**, não aqui.

---

## 1. 🔑 Criar a conta de desenvolvedor (uma vez só)

1. Acesse **https://partner.microsoft.com/dashboard** e entre com uma conta Microsoft.
2. Registre-se no programa **Windows & Xbox** (conta de desenvolvedor).
   - Conta **individual**: taxa única de ~**US$ 19** (sem mensalidade).
   - É preciso verificar identidade (nome, endereço). Como pessoa física, use **Joaquim Pedro de Morais Filho**.
3. Pronto: você terá acesso ao **Partner Center**, onde cada app é reservado, enviado e revisado.

> Cada envio passa por **revisão manual da Microsoft** (normalmente 1–3 dias). Nenhum app fica público antes de ser aprovado.

---

## 2. Reservar o nome do app (gera a identidade)

No Partner Center: **Apps and games → New product → reserve o nome**.

Depois, em **Product management → Product identity**, anote estes três valores — eles são a "identidade" do pacote:

| Campo no Partner Center        | Onde usar |
|--------------------------------|-----------|
| **Package/Identity/Name**      | PWABuilder (Package ID) ou `AppxManifest.xml` → `Identity Name` |
| **Publisher**                  | PWABuilder (Publisher ID) ou `AppxManifest.xml` → `Identity Publisher` (ex.: `CN=XXXX...`) |
| **Publisher display name**     | PWABuilder (Publisher display name) |

> ⚠️ É por isso que o **pacote final só pode ser gerado depois** de reservar o nome: esses valores não existem antes.

---

## 3. Caminho A — PWA (web apps) via PWABuilder  ⭐ mais rápido

Os web apps já foram preparados como **PWA instalável** (manifest + service worker + ícones). Lista e URLs em [`README.md`](README.md).

Para cada app:

1. Abra **https://www.pwabuilder.com** e cole a URL do app, por exemplo:
   `https://elevbit-ai.github.io/plantacad/`
2. O PWABuilder valida o manifest e o service worker (já devem passar ✓).
3. Clique em **Package For Stores → Windows (Microsoft Store)**.
4. Preencha a **identidade** com os três valores do passo 2 (Package ID, Publisher ID, Publisher display name).
5. Baixe o pacote **`.msixbundle`** (vem também um `.classic.appxbundle` e a versão de teste).
6. No Partner Center, na submissão do app: **Packages → faça upload** do `.msixbundle`.
7. Preencha a **listagem** (descrição, screenshots, categoria) usando o arquivo de `listings/` correspondente.
8. **Submeta para revisão.**

Isso vale para: PlantaCAD, InpioJus, AtomicSim, 02quest Vault (prontos) e, depois de ligar o Pages, zkinv, OpS Image Data, nexus-store, cobol-db-api, etc.

---

## 4. Caminho B — MSIX (ferramentas Windows)

Para apps de desktop (Win OpS, OpS Silence, Zicutake Browser, OpS Text Editor, OpS Crypt desktop, JP TERMINAL, CertForge).

**Pré-passo — ter um `.exe` de entrada:**
- App em **Python** → gere o exe com **PyInstaller**: `pyinstaller --onefile --noconsole app.py` (sai em `dist/app.exe`).
- App em **.bat/.ps1/.hta** (ex.: JP TERMINAL) → inclua um **launcher** (veja `msix-template/LEIA-ME.md`).
- App já compilado (`.exe`) → use direto.

**Empacotar:**
1. Copie a pasta `msix-template/`.
2. Edite `AppxManifest.xml`: troque `Identity Name`, `Publisher` e `PublisherDisplayName` pelos valores do Partner Center (passo 2); ajuste `Executable` e `DisplayName`.
3. Coloque o exe e os arquivos do app na pasta, junto com a pasta `Assets/` (tiles já incluídos — troque pelos do app).
4. Rode `build-msix.ps1` (usa `makeappx.exe` + `signtool.exe` do Android/Windows SDK) para gerar o `.msix`.
5. Faça upload no Partner Center.

> Para a Store, **não é obrigatório assinar** o MSIX (a Microsoft reassina). A assinatura com certificado próprio serve só para **instalar e testar localmente**.

---

## 5. Requisitos da listagem (vale para os dois caminhos)

Para cada app, o Partner Center pede:

- **Nome** reservado.
- **Descrição** (curta + longa) — prontas em `listings/`.
- **Ícone da Store 300×300** — em `assets/<app>/StoreLogo-300.png`.
- **Pelo menos 1 screenshot** (1366×768 recomendado para desktop; ou 1080×1920 para mobile). *Dica: abra o app no navegador e capture a tela real — fica melhor que um mock.*
- **Categoria** e **classificação etária** (questionário IARC).
- **Política de privacidade (URL)** — para apps que não coletam dados, uma página simples dizendo isso já basta (pode ficar no GitHub Pages).
- **Mercados** (selecione Brasil + global) e **preço** (Grátis).

---

## 6. Elegibilidade dos projetos (resumo)

| App | Tipo | Caminho na Store | Status |
|-----|------|------------------|--------|
| PlantaCAD | Web | PWA | ✅ pronto (PWA no ar) |
| InpioJus | Web | PWA | ✅ pronto (PWA no ar) |
| AtomicSim | Web | PWA | ✅ pronto (PWA no ar) |
| 02quest Vault | Web | PWA | ✅ pronto (PWA no ar) |
| zkinv / zkinv-futebol | Web | PWA | ⚙️ ligar Pages + PWA |
| OpS Image Data | Web | PWA | ⚙️ ligar Pages + PWA |
| nexus-store, cobol-db-api | Web | PWA | ⚙️ ligar Pages + PWA |
| JP TERMINAL | Windows | MSIX | ⚙️ via template |
| Win OpS, OpS Silence | Windows | MSIX | ⚙️ via template (+ exe) |
| Zicutake Browser, OpS Text Editor | Windows (Python) | MSIX | ⚙️ PyInstaller + template |
| OpS Crypt (desktop) | Windows | MSIX | ⚙️ via template |
| JP Teleprompter, JP Secure Lock, OpS Bank Crypto, OpS Crypt Android, usacomment-ops, ops-*-android | **Android** | ❌ não entra | → **Google Play** |

---

**Autor:** Joaquim Pedro de Morais Filho · j360074@hotmail.com
