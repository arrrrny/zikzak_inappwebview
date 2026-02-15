<div align="center">

# 🚀 ZikZak InAppWebView

### *The WebView Plugin That Actually Gets Updates*

<img src="https://img.shields.io/badge/Maintenance-Active%20AF-brightgreen" alt="Actively Maintained">
<img src="https://img.shields.io/badge/Breaking%20Changes-Welcome-orange" alt="Breaking Changes Welcome">
<img src="https://img.shields.io/badge/Maintained%20By-Human%20%2B%20AI-blueviolet" alt="Human + AI">
<img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20macOS-blue" alt="Platforms">

---

A Flutter plugin for inline WebView, headless WebView, and in-app browser windows. But you already knew that. What you might not know is **this one actually gets maintained**. 🎉

This is a fork of the incredibly popular [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) which, despite having 3.6k stars and being used by thousands of developers, has been left to gather dust. 🤷

**But fear not!** This fork exists because someone had to step up. That someone is me (a human) and my trusty AI sidekick. Together, we're like Batman and Robin, except we fix WebView bugs instead of fighting crime.

</div>

---

## 🎭 The Origin Story

Picture this: A widely-used Flutter WebView plugin. Thousands of developers depending on it. Critical bugs piling up. iOS 18 crashes everywhere. Xcode 16 build failures. Pull requests aging like fine wine (but not in a good way).

The original maintainer? MIA.

So here we are. **ZikZak InAppWebView** - where:
- ✅ Issues get responses (sometimes within hours!)
- ✅ PRs get reviewed (yes, really!)
- ✅ Critical bugs get fixed
- ✅ The maintainer actually shows up
- ✅ An AI helps maintain it (welcome to 2025!)

---

## 🤖 Meet Your Maintenance Team

**Human (ARRRRNY):** Brings the vision, coffee addiction, and occasional frustration
**AI (Claude):** Brings the tireless code review, pattern recognition, and inability to drink coffee

Together, we're modernizing this package with:
- 🔒 **Security-first approach** (no more JavaScript-based CSP injection nonsense)
- 🏗️ **Clean architecture** (SOLID principles are our love language)
- 🖥️ **Multi-Platform Support** (macOS is BACK! Windows & Web on the radar)
- ⚡ **Modern WebView APIs** (WKContentWorld, WebMessageListener, the cool stuff)
- 💥 **Breaking changes are welcome** (backward compatibility is overrated)

---

## 🆘 WANTED: Contributors (That's You!)

Listen, I can't do this alone. Well, technically I can with my AI buddy, but wouldn't it be more fun with YOU?

### 🐛 Found a Bug?
**PLEASE open an issue!** Unlike the original repo, we actually read them.

### 💡 Have an Idea?
Open an issue! Let's discuss it!

### 🛠️ Want to Contribute Code?
**HELL YES!** PRs are welcome! We have:
- 📋 A comprehensive [modernization plan](MODERNIZATION_PLAN.md)
- 🎯 Clear guidelines
- 👀 Actual code reviews

**We're especially looking for help with:**
- macOS implementation details
- Windows support (future)
- Testing (we can dream, can't we?)

---

## 🎯 Roadmap to v3.0+

We're not just fixing bugs. We're **modernizing the entire codebase**.

### Phase 1: Critical Security & Bugs 🔴 (Done)
- Fix iOS 18 crashes
- Fix Xcode 16 builds
- Add certificate pinning
- Implement HTTPS-only mode

### Phase 2: Architecture Refactoring 🏗️ (In Progress)
- Break up monolithic classes
- Apply SOLID principles
- **Re-introduce macOS support** (Started!)

### Phase 3-6: More Awesome Stuff
Read the [full plan](MODERNIZATION_PLAN.md).

---

## 📦 Installation

```yaml
dependencies:
  zikzak_inappwebview: ^4.0.0
```

Or live on the edge:
```yaml
dependencies:
  zikzak_inappwebview:
    git:
      url: https://github.com/arrrrny/zikzak_inappwebview.git
      ref: main
```

---

## 🔒 Security Features (v3.0+)

ZikZak InAppWebView includes enterprise-grade security features enabled by default:

### Google Safe Browsing ✅ ENABLED BY DEFAULT
Protects users from phishing, malware, and unwanted software.

### Other Security Features
- **Certificate Pinning**: SHA-256 public key pinning
- **HTTPS-Only Mode**: Block or upgrade insecure HTTP requests
- **URL Scheme Validation**: Block dangerous schemes
- **Content Security Policy**: Proper HTTP header-based CSP

📖 **Full Documentation**: [SECURITY_FEATURES.md](SECURITY_FEATURES.md)

---

## 📋 Requirements

### Current (v4.0)
- Dart: `>=3.0.0 <4.0.0`
- Flutter: `>=3.10.0`
- Android: `minSdk 24` (Android 7.0+), `compileSdk 36`
- iOS: `15.0+`, Xcode `14.3+`
- macOS: `11.0+` (Alpha)

---

## 💬 Communication

- 🐛 **Bugs:** [Open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues/new)
- 💡 **Feature Requests:** [Open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues/new)
- 🤔 **Questions:** [Discussions](https://github.com/arrrrny/zikzak_inappwebview/discussions)

---

## 🙏 Thanks & Credits

### Original Creator & Contributors
Massive shoutout to [Lorenzo Pichilli](https://github.com/pichillilorenzo) for creating the original flutter_inappwebview.

### Why This Fork Exists
Not out of disrespect, but out of necessity. When a critical plugin is no longer maintained, someone has to step up.

---

## ⚖️ License

Apache License 2.0 (same as the original)

---

## 💼 Maintainer

**ARRRRNY** ([GitHub](https://github.com/arrrrny)) + **Claude AI**

*"The dynamic duo nobody asked for, but everyone needed."*
