import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    'intro',
    'security-features',
    {
      type: 'category',
      label: 'WebView',
      items: [
        'webview/in-app-webview',
        {
          type: 'category',
          label: 'JavaScript',
          items: [
            'webview/javascript/injection',
            'webview/javascript/communication',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'In-App Browsers',
      items: [
        'in-app-browsers/in-app-browser',
      ],
    },
    {
      type: 'category',
      label: 'Utilities',
      items: [
        'utilities/cookie-manager',
      ],
    },
  ],
};

export default sidebars;
