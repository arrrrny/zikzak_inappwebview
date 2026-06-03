import type { ReactNode } from "react";
import clsx from "clsx";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import Heading from "@theme/Heading";

import styles from "./index.module.css";

const features = [
  {
    icon: "📱",
    title: "Cross-Platform",
    description:
      "Android, iOS, Web, macOS, Windows, Linux — one API for all platforms with platform-specific features.",
  },
  {
    icon: "🔧",
    title: "Rich API",
    description:
      "Full control over navigation, cookies, JavaScript bridge, content blocking, file picking, and more.",
  },
  {
    icon: "🛡️",
    title: "Modern Security",
    description:
      "Enhanced security features, proactive updates, and support for the latest platform APIs.",
  },
  {
    icon: "⚡",
    title: "Actively Maintained",
    description:
      "Community-driven fork of flutter_inappwebview with rapid bug fixes, PR merges, and regular releases.",
  },
  {
    icon: "🔄",
    title: "JavaScript Bridge",
    description:
      "Bidirectional Dart-JavaScript communication with full type safety and security model.",
  },
  {
    icon: "📄",
    title: "Full Browser Features",
    description:
      "Headless WebView, in-app browser, pull-to-refresh, custom schemes, content blockers, and more.",
  },
];

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx("hero hero--primary", styles.heroBanner)}>
      <div className="container">
        <Heading as="h1" className="hero__title">
          {siteConfig.title}
        </Heading>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className="hero-badge-container">
          <img
            src="https://img.shields.io/badge/Maintenance-Active-brightgreen"
            alt="Actively Maintained"
          />
          <img
            src="https://img.shields.io/badge/version-4.2.3-blue"
            alt="Version 4.2.3"
          />
          <img
            src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue"
            alt="Platforms"
          />
          <img
            src="https://img.shields.io/badge/License-Apache%202.0-blue"
            alt="License"
          />
        </div>
        <div className={styles.buttons} style={{ marginTop: "2rem" }}>
          <Link
            className="button button--secondary button--lg"
            to="/docs/intro"
          >
            Get Started →
          </Link>
          <Link
            className="button button--outline button--secondary button--lg"
            to="https://pub.dev/packages/zikzak_inappwebview"
            style={{ marginLeft: "1rem" }}
          >
            pub.dev
          </Link>
          <Link
            className="button button--outline button--secondary button--lg"
            to="https://github.com/arrrrny/zikzak_inappwebview"
            style={{ marginLeft: "1rem" }}
          >
            GitHub
          </Link>
        </div>
      </div>
    </header>
  );
}

function FeatureCard({
  icon,
  title,
  description,
}: {
  icon: string;
  title: string;
  description: string;
}) {
  return (
    <div className="col col--4" style={{ marginBottom: "2rem" }}>
      <div className="feature-card">
        <div className="feature-card__icon">{icon}</div>
        <div className="feature-card__title">{title}</div>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function Home(): ReactNode {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.title}
      description="A feature-rich WebView plugin for Flutter applications. Community-driven fork with active maintenance."
    >
      <HomepageHeader />
      <main>
        <section style={{ padding: "4rem 0" }}>
          <div className="container">
            <div className="row">
              {features.map((feature, idx) => (
                <FeatureCard key={idx} {...feature} />
              ))}
            </div>
          </div>
        </section>

        <section className="sponsor-section">
          <div className="container">
            <Heading as="h2" style={{ marginBottom: "1rem" }}>
              🚀 Sponsored by ZikZak AI
            </Heading>
            <p
              style={{
                color: "var(--ifm-color-emphasis-600)",
                maxWidth: "600px",
                margin: "0 auto 1.5rem",
              }}
            >
              An AI-Powered Price Comparison app — scan barcodes and discover
              amazing savings instantly. Your personal shopping assistant that
              never sleeps.
            </p>
            <div
              style={{
                display: "flex",
                gap: "1rem",
                justifyContent: "center",
                flexWrap: "wrap",
              }}
            >
              <a href="https://apps.apple.com/tr/app/zik-zak/id1563425450">
                <img
                  src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg"
                  height="50"
                  alt="Download on the App Store"
                />
              </a>
              <a href="https://play.google.com/store/apps/details?id=dev.zuzu.zingo">
                <img
                  src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
                  height="50"
                  alt="Get it on Google Play"
                />
              </a>
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
}
