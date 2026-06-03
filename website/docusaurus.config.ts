import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

const config: Config = {
  title: "ZikZak InAppWebView",
  tagline:
    "The Feature-Rich WebView Plugin for Flutter (Android, iOS, Web, macOS, Windows, Linux)",
  favicon: "img/favicon.ico",

  future: {
    v4: true,
  },

  url: "https://arrrrny.github.io",
  baseUrl: "/zikzak_inappwebview/",

  organizationName: "arrrrny",
  projectName: "zikzak_inappwebview",
  trailingSlash: false,

  onBrokenLinks: "warn",

  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          editUrl:
            "https://github.com/arrrrny/zikzak_inappwebview/tree/main/website/",
        },
        blog: false,
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: "img/logo.svg",
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: "ZikZak InAppWebView",
      logo: {
        alt: "ZikZak InAppWebView Logo",
        src: "img/logo.svg",
      },
      items: [
        {
          type: "docSidebar",
          sidebarId: "tutorialSidebar",
          position: "left",
          label: "Docs",
        },
        {
          href: "https://pub.dev/packages/zikzak_inappwebview",
          label: "pub.dev",
          position: "right",
        },
        {
          href: "https://github.com/arrrrny/zikzak_inappwebview",
          label: "GitHub",
          position: "right",
        },
        {
          href: "https://github.com/arrrrny/zikzak_inappwebview/issues",
          label: "Issues",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Docs",
          items: [
            {
              label: "Getting Started",
              to: "/docs/intro",
            },
            {
              label: "InAppWebView",
              to: "/docs/webview/in-app-webview",
            },
            {
              label: "JavaScript Communication",
              to: "/docs/webview/javascript/communication",
            },
            {
              label: "Cookie Manager",
              to: "/docs/utilities/cookie-manager",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "GitHub Issues",
              href: "https://github.com/arrrrny/zikzak_inappwebview/issues",
            },
            {
              label: "GitHub Discussions",
              href: "https://github.com/arrrrny/zikzak_inappwebview/discussions",
            },
            {
              label: "Stack Overflow",
              href: "https://stackoverflow.com/questions/tagged/flutter-inappwebview",
            },
          ],
        },
        {
          title: "More",
          items: [
            {
              label: "pub.dev",
              href: "https://pub.dev/packages/zikzak_inappwebview",
            },
            {
              label: "API Reference",
              href: "https://pub.dev/documentation/zikzak_inappwebview/latest/",
            },
            {
              label: "GitHub",
              href: "https://github.com/arrrrny/zikzak_inappwebview",
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} ZikZak InAppWebView. Maintained by <a href="https://github.com/arrrrny">ARRRRNY</a>. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: [
        "dart",
        "kotlin",
        "swift",
        "java",
        "groovy",
        "yaml",
        "bash",
      ],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
