import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'ZikZak InAppWebView',
  tagline: 'The Feature-Rich WebView Plugin for Flutter (Android, iOS, Web, macOS, Windows, Linux)',
  favicon: 'img/favicon.ico',

  // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
  future: {
    v4: true, // Improve compatibility with the upcoming Docusaurus v4
  },

  // Set the production url of your site here
  url: 'https://arrrrny.github.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/zikzak_inappwebview/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'arrrrny', // Usually your GitHub org/user name.
  projectName: 'zikzak_inappwebview', // Usually your repo name.
  trailingSlash: false,

  onBrokenLinks: 'throw',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/arrrrny/zikzak_inappwebview/tree/main/website/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'ZikZak InAppWebView',
      logo: {
        alt: 'ZikZak InAppWebView Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          href: 'https://pub.dev/packages/zikzak_inappwebview',
          label: 'pub.dev',
          position: 'right',
        },
        {
          href: 'https://github.com/arrrrny/zikzak_inappwebview',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Intro',
              to: '/docs/intro',
            },
            {
              label: 'Security Features',
              to: '/docs/security-features',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub Issues',
              href: 'https://github.com/arrrrny/zikzak_inappwebview/issues',
            },
            {
              label: 'GitHub Discussions',
              href: 'https://github.com/arrrrny/zikzak_inappwebview/discussions',
            },
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/flutter-inappwebview',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/arrrrny/zikzak_inappwebview',
            },
            {
              label: 'pub.dev',
              href: 'https://pub.dev/packages/zikzak_inappwebview',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} ZikZak InAppWebView. Actively maintained by ARRRRNY + Claude AI. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['dart', 'kotlin', 'swift', 'java', 'groovy', 'yaml', 'bash'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
