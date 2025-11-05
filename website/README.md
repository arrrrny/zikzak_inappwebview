# ZikZak InAppWebView Documentation Website

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

## Installation

```bash
npm install
```

## Local Development

```bash
npm start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

## Build

```bash
npm run build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

## Deployment

The website is automatically deployed to GitHub Pages when changes are pushed to the `main` branch (in the `website/` directory).

The deployment is handled by the GitHub Actions workflow at `.github/workflows/deploy-docs.yml`.

**Website URL:** https://arrrrny.github.io/zikzak_inappwebview/

## Structure

```
website/
├── blog/                  # Blog posts
├── docs/                  # Documentation
├── src/                   # React components and pages
├── static/                # Static assets
├── docusaurus.config.ts   # Site configuration
├── sidebars.ts            # Sidebar configuration
└── package.json           # Dependencies
```

## Contributing

### Adding Documentation

Create new `.md` or `.mdx` files in the `docs/` directory with front matter:

```markdown
---
sidebar_position: 5
title: My Page Title
---

# Content here
```

### Adding Blog Posts

Create new files in `blog/` with date format `YYYY-MM-DD-post-title.md`:

```markdown
---
slug: my-post
title: My Post Title
authors: [arrrrny]
tags: [flutter, webview]
---

Content here...
```

---

**Made with 💙 by ARRRRNY + Claude AI**
