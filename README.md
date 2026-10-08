<div align="center">

# 🏪 OpS / Elevbit — Kit de publicação na Microsoft Store

Tudo pronto para levar os apps **Windows** e **web (PWA)** de
**Joaquim Pedro de Morais Filho** à Microsoft Store: pacotes, artes, textos de listagem e o passo a passo.

**→ Comece pelo [GUIA-PUBLICACAO.md](GUIA-PUBLICACAO.md)**

</div>

---

## O que tem aqui

```
GUIA-PUBLICACAO.md     Passo a passo completo (conta, PWABuilder, MSIX, listagem)
README.md              Este arquivo
listings/              Textos de listagem (PT + EN) por app
assets/<app>/          Artes da Store (300x300, 150, 44, wide) por app
msix-template/         Template MSIX para as ferramentas Windows (+ build-msix.ps1)
docs/                  Página (GitHub Pages) com os PWAs e links de instalação
```

## Apps prontos como PWA (instaláveis e prontos para o PWABuilder)

| App | URL (instala no navegador e alimenta o PWABuilder) |
|-----|------|
| **PlantaCAD** — editor de plantas baixas | https://elevbit-ai.github.io/plantacad/ |
| **InpioJus** — IA jurídica | https://elevbit-ai.github.io/inpiojus/ |
| **AtomicSim** — simulador de fissão nuclear | https://elevbit-ai.github.io/atomicsim/ |
| **02quest Vault** — banco ultradenso + AES-256 | https://elevbit-ai.github.io/02quest-vault/ |
| **OpS Image Data** — esteganografia | https://elevbit-ai.github.io/ops-image-data/ |
| **zkinv** — previsibilidade de ativos (IA) | https://elevbit-ai.github.io/zkinv/ |
| **zkinv Futebol** — previsor de partidas | https://elevbit-ai.github.io/zkinv-futebol/ |
| **Nexus Store** — loja digital USDT (BEP20) | https://elevbit-ai.github.io/nexus-store/ |
| **COBOL DB API** — banco de dados + API | https://elevbit-ai.github.io/cobol-db-api/ |

Cada um já tem `manifest.json`, `sw.js` e ícones (192/512/maskable) publicados. No celular ou no Edge/Chrome dá para **instalar agora** pelo menu “Instalar app”.

## Exemplo MSIX pronto (Windows)

Em [`msix-template/exemplo-jp-terminal/`](msix-template/exemplo-jp-terminal/) há o pacote do **JP TERMINAL** montado (launcher `JPTerminal.exe` compilado + script + manifesto + artes). Basta `makeappx pack` (Windows SDK) para gerar o `.msix`.

## Caminho de cada projeto

- **Web → PWA** (via [PWABuilder](https://www.pwabuilder.com)): rápido, usa os sites do GitHub Pages.
- **Windows → MSIX** (via `msix-template/`): para os utilitários de desktop.
- **Android → Google Play** (❌ não entra na Microsoft Store).

Veja a tabela completa de elegibilidade no [guia](GUIA-PUBLICACAO.md#6-elegibilidade-dos-projetos-resumo).

---

**Autor:** Joaquim Pedro de Morais Filho · j360074@hotmail.com · © 2026
