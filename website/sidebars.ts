import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Project Info',
      items: [
        'modernization-plan',
        'security-features',
        'modernization-summary',
      ],
    },
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
    {
      type: 'category',
      label: 'Docusaurus Tutorial',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: 'Tutorial - Basics',
          items: [
            'tutorial-basics/create-a-document',
            'tutorial-basics/create-a-blog-post',
            'tutorial-basics/create-a-page',
            'tutorial-basics/markdown-features',
            'tutorial-basics/deploy-your-site',
            'tutorial-basics/congratulations',
          ],
        },
        {
          type: 'category',
          label: 'Tutorial - Extras',
          items: [
            'tutorial-extras/manage-docs-versions',
            'tutorial-extras/translate-your-site',
          ],
        },
      ],
    },
  ],
};

export default sidebars;
