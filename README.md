<div align="center">

# 🚀 ZikZak InAppWebView

### *The WebView Plugin That Actually Gets Updates*

<img src="https://img.shields.io/badge/Maintenance-Active%20AF-brightgreen" alt="Actively Maintained">
<img src="https://img.shields.io/badge/Breaking%20Changes-Welcome-orange" alt="Breaking Changes Welcome">
<img src="https://img.shields.io/badge/Maintained%20By-Human%20%2B%20AI-blueviolet" alt="Human + AI">
<img src="https://img.shields.io/badge/Original%20Repo-RIP-lightgrey" alt="Original Repo Status">

---

A Flutter plugin for inline WebView, headless WebView, and in-app browser windows. But you already knew that. What you might not know is **this one actually gets maintained**. 🎉

This is a fork of the incredibly popular [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) which, despite having 3.6k stars and being used by thousands of developers, has been left to gather dust by its original maintainer who apparently has more important things to do than merge PRs or respond to critical bugs. 🤷

**But fear not!** This fork exists because someone had to step up. That someone is me (a human) and my trusty AI sidekick. Together, we're like Batman and Robin, except we fix WebView bugs instead of fighting crime.

</div>

---

## 🎭 The Origin Story

Picture this: A widely-used Flutter WebView plugin. Thousands of developers depending on it. Critical bugs piling up. iOS 18 crashes everywhere. Xcode 16 build failures. Pull requests aging like fine wine (but not in a good way).

The original maintainer? MIA. High ego, low maintenance.

So here we are. **ZikZak InAppWebView** - where:
- ✅ Issues get responses (sometimes within hours, imagine that!)
- ✅ PRs get reviewed (yes, really!)
- ✅ Critical bugs get fixed (wild concept, I know)
- ✅ The maintainer actually shows up (shocking!)
- ✅ An AI helps maintain it (welcome to 2025, baby!)

---

## 🤖 Meet Your Maintenance Team

**Human (ARRRRNY):** Brings the vision, coffee addiction, and occasional frustration
**AI (Claude):** Brings the tireless code review, pattern recognition, and inability to drink coffee

Together, we're modernizing this package with:
- 🔒 **Security-first approach** (no more JavaScript-based CSP injection nonsense)
- 🏗️ **Clean architecture** (SOLID principles are our love language)
- 📱 **Android & iOS focus** (sorry macOS/Windows/Web, you're getting the boot in v3.0)
- ⚡ **Modern WebView APIs** (WKContentWorld, WebMessageListener, the cool stuff)
- 💥 **Breaking changes are welcome** (backward compatibility is overrated)

---

## 🆘 WANTED: Contributors (That's You!)

Listen, I can't do this alone. Well, technically I can with my AI buddy, but wouldn't it be more fun with YOU?

### 🐛 Found a Bug?
**PLEASE open an issue!** Unlike the original repo, we actually read them. Crazy, right?

### 💡 Have an Idea?
Open an issue! Let's discuss it! We don't bite! (The AI can't bite, it has no mouth. I won't bite either, promise.)

### 🛠️ Want to Contribute Code?
**HELL YES!** PRs are welcome! We have:
- 📋 A comprehensive [modernization plan](MODERNIZATION_PLAN.md) (35 tracked issues!)
- 🎯 Clear guidelines (coming soon™)
- 👀 Actual code reviews (not ghosting!)
- 🎉 A maintainer who says "thank you" (revolutionary!)

**We're especially looking for help with:**
- iOS 18.4/18.5 crash fixes
- Xcode 16 compatibility
- Security improvements (certificate pinning, anyone?)
- Android WebView modernization
- Testing (we can dream, can't we?)

---

## 🎯 Roadmap to v3.0

We're not just fixing bugs. We're **modernizing the entire codebase**. Check out our [comprehensive plan](MODERNIZATION_PLAN.md):

### Phase 1: Critical Security & Bugs 🔴
- Fix iOS 18 crashes (because Apple gonna Apple)
- Fix Xcode 16 builds (because Apple really gonna Apple)
- Add certificate pinning (MITM attacks are so 2010)
- Implement HTTPS-only mode (HTTP is for dinosaurs)

### Phase 2: Architecture Refactoring 🏗️
- Break up monolithic 2000+ line classes (a class should do ONE thing, not EVERYTHING)
- Apply SOLID principles (not just for furniture)
- Remove platforms nobody asked us to support

### Phase 3-6: More Awesome Stuff
Read the [full plan](MODERNIZATION_PLAN.md). It's 400+ lines of pure modernization goodness.

---

## 📦 Installation

```yaml
dependencies:
  zikzak_inappwebview: ^2.4.28
```

Or live on the edge:
```yaml
dependencies:
  zikzak_inappwebview:
    git:
      url: https://github.com/arrrrny/zikzak_inappwebview.git
      ref: main  # or whatever branch has the feature you desperately need
```

---

## 🔒 Security Features (v3.0+)

ZikZak InAppWebView includes enterprise-grade security features enabled by default:

### Google Safe Browsing ✅ ENABLED BY DEFAULT
Protects users from phishing, malware, and unwanted software using Google's threat intelligence.

```dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    safeBrowsingEnabled: true,  // ← Already enabled!
  ),
  onSafeBrowsingHit: (controller, url, threatType) async {
    // Handle detected threats
    return SafeBrowsingResponse(
      action: SafeBrowsingResponseAction.BACK_TO_SAFETY,
      report: true,
    );
  },
)
```

### Other Security Features
- **Certificate Pinning**: SHA-256 public key pinning for MITM prevention
- **HTTPS-Only Mode**: Block or upgrade insecure HTTP requests
- **URL Scheme Validation**: Block dangerous schemes (javascript:, file:, etc.)
- **Content Security Policy**: Proper HTTP header-based CSP implementation

📖 **Full Documentation**: [SECURITY_FEATURES.md](SECURITY_FEATURES.md)

---

## 📋 Requirements

### Current (v3.0)
- Dart: `>=2.17.0 <4.0.0`
- Flutter: `>=3.0.0`
- Android: `minSdk 24` (Android 7.0+), `compileSdk 36`
- iOS: `15.0+`, Xcode `14.3+`
- Platforms: **Android & iOS ONLY** (mobile-first, lean and clean)

### Legacy (v2.x)
- Android: `minSdk 19`, `compileSdk 36`
- iOS: `13.0+`
- Platforms: Android, iOS, macOS, Web (deprecated)

---

## 🚨 Breaking Changes in v3.0

v3.0 breaks things. Intentionally. Because sometimes you need to break eggs to make an omelet. Or in this case, break backward compatibility to make a secure, modern, maintainable plugin.

Completed changes:
- ✅ macOS/Windows/Web support removed (focus is everything)
- ✅ Minimum Android SDK raised to 24 - Android 7.0+ (bye bye Android 4.4-6.0)
- ✅ Minimum iOS raised to 15.0+ (iOS 13-14 had a good run)
- ✅ Google Safe Browsing enabled by default (security first)

Coming soon:
- ⏳ 30+ redundant settings removal (because 70 settings was insane)
- ⏳ JavaScript disabled by default (security first, convenience second)

See [MODERNIZATION_PLAN.md](MODERNIZATION_PLAN.md) for the full hit list.

---

## 🤝 How to Contribute

### 1. Check Existing Issues
Don't waste time on duplicates. We have [35 tracked issues](https://github.com/arrrrny/zikzak_inappwebview/issues) waiting for heroes like you.

### 2. Open a Discussion First (for Big Changes)
Got a wild idea? Let's chat about it before you spend 3 weeks coding something we might not merge.

### 3. Write Tests (Please!)
We're trying to be adults here. Tests are good. Tests are your friends.

### 4. Follow the Architecture
We're going full Clean Architecture + SOLID. If you don't know what that means, that's okay! We'll help you learn.

### 5. Be Patient (But Not Too Patient)
We're fast, but we're not instant. Give us a day or two. Unlike the original maintainer, we WILL respond.

---

## 💬 Communication

- 🐛 **Bugs:** [Open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues/new)
- 💡 **Feature Requests:** [Open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues/new)
- 🤔 **Questions:** [Discussions](https://github.com/arrrrny/zikzak_inappwebview/discussions) (coming soon) or [open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues/new)
- 🎉 **Success Stories:** We love hearing these! Open an issue titled "This plugin is awesome because..."

---

## 🙏 Thanks & Credits

### Original Creator & Contributors
Massive shoutout to [Lorenzo Pichilli](https://github.com/pichillilorenzo) for creating the original flutter_inappwebview. It was (and still is) an incredible piece of work. You built something thousands of developers rely on.

Also thanks to the **80+ contributors** who helped build the original plugin. Your work lives on in this fork. (See full contributor list below)

### Why This Fork Exists
Not out of disrespect, but out of necessity. When a critical plugin is no longer maintained, someone has to step up. This is me stepping up.

---

## 📚 Documentation

- **[Modernization Plan](MODERNIZATION_PLAN.md)** - The master plan for v3.0
- **[Modernization Summary](MODERNIZATION_SUMMARY.md)** - TL;DR version
- **[Issue Templates](ISSUE_TEMPLATES.md)** - How we track work
- **API Documentation** - Coming soon (we're working on it, I swear!)

---

## 📊 Project Status

| Metric | Status |
|--------|--------|
| Actively Maintained | ✅ YES |
| Issues Responded To | ✅ Within 24-48hrs usually |
| PRs Reviewed | ✅ Yes, actually! |
| Security Updates | ✅ Priority |
| Breaking Changes | ✅ Welcomed in v3.0 |
| Coffee Consumption | ☕☕☕ High |
| AI Assistance | 🤖 Active |

---

## ⚖️ License

Apache License 2.0 (same as the original)

---

## 🎬 The Bottom Line

This plugin is:
- ✅ **Actively maintained** (shocking, I know)
- ✅ **Open to contributions** (please help us!)
- ✅ **Focused on security** (no more JS-based hacks)
- ✅ **Modern architecture** (Clean Code isn't just a book title)
- ✅ **Maintained by human + AI** (the future is now)

Unlike the original repo:
- ✅ We respond to issues
- ✅ We review PRs
- ✅ We fix critical bugs
- ✅ We show up

---

## 🌟 Star This Repo!

If you find this useful (or just enjoy the humor), give us a star! ⭐

It helps others find this maintained fork instead of the abandoned original.

---

## 💼 Maintainer

**ARRRRNY** ([GitHub](https://github.com/arrrrny)) + **Claude AI**

*"The dynamic duo nobody asked for, but everyone needed."*

---

<div align="center">

## Contributors ✨

Thanks goes to these wonderful people from the original repo and this fork:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://blog.alexv525.com/"><img src="https://avatars.githubusercontent.com/u/15884415?v=4?s=100" width="100px;" alt="Alex Li"/><br /><sub><b>Alex Li</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=AlexV525" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/crazecoder"><img src="https://avatars.githubusercontent.com/u/18387906?v=4?s=100" width="100px;" alt="1/2"/><br /><sub><b>1/2</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=crazecoder" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cbodin"><img src="https://avatars.githubusercontent.com/u/220255?v=4?s=100" width="100px;" alt="Christofer Bodin"/><br /><sub><b>Christofer Bodin</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=cbodin" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/matthewlloyd"><img src="https://avatars.githubusercontent.com/u/2041996?v=4?s=100" width="100px;" alt="Matthew Lloyd"/><br /><sub><b>Matthew Lloyd</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=matthewlloyd" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/carloserazo47"><img src="https://avatars.githubusercontent.com/u/83635384?v=4?s=100" width="100px;" alt="C E"/><br /><sub><b>C E</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=carloserazo47" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/robsonmeemo"><img src="https://avatars.githubusercontent.com/u/47990393?v=4?s=100" width="100px;" alt="Robson Araujo"/><br /><sub><b>Robson Araujo</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=robsonmeemo" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ryanhz"><img src="https://avatars.githubusercontent.com/u/1142612?v=4?s=100" width="100px;" alt="Ryan"/><br /><sub><b>Ryan</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=ryanhz" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://codeeagle.github.io/"><img src="https://avatars.githubusercontent.com/u/2311352?v=4?s=100" width="100px;" alt="CodeEagle"/><br /><sub><b>CodeEagle</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=CodeEagle" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tneotia"><img src="https://avatars.githubusercontent.com/u/50850142?v=4?s=100" width="100px;" alt="Tanay Neotia"/><br /><sub><b>Tanay Neotia</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=tneotia" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/panndoraBoo"><img src="https://avatars.githubusercontent.com/u/8928207?v=4?s=100" width="100px;" alt="Jamie Joost"/><br /><sub><b>Jamie Joost</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=panndoraBoo" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://deandreamatias.com/"><img src="https://avatars.githubusercontent.com/u/21011641?v=4?s=100" width="100px;" alt="Matias de Andrea"/><br /><sub><b>Matias de Andrea</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=deandreamatias" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://blog.csdn.net/j550341130"><img src="https://avatars.githubusercontent.com/u/17899073?v=4?s=100" width="100px;" alt="YouCii"/><br /><sub><b>YouCii</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=YouCii" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cutzmf"><img src="https://avatars.githubusercontent.com/u/1662033?v=4?s=100" width="100px;" alt="Salnikov Sergey"/><br /><sub><b>Salnikov Sergey</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=cutzmf" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/a00012025"><img src="https://avatars.githubusercontent.com/u/12824216?v=4?s=100" width="100px;" alt="Po-Jui Chen"/><br /><sub><b>Po-Jui Chen</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=a00012025" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Manuito83"><img src="https://avatars.githubusercontent.com/u/4816367?v=4?s=100" width="100px;" alt="Manuito"/><br /><sub><b>Manuito</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Manuito83" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/setcy"><img src="https://avatars.githubusercontent.com/u/86180691?v=4?s=100" width="100px;" alt="setcy"/><br /><sub><b>setcy</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=setcy" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/EArminjon2"><img src="https://avatars.githubusercontent.com/u/92172436?v=4?s=100" width="100px;" alt="EArminjon"/><br /><sub><b>EArminjon</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=EArminjon2" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/ashank-bharati-497989127/"><img src="https://avatars.githubusercontent.com/u/22197948?v=4?s=100" width="100px;" alt="Ashank Bharati"/><br /><sub><b>Ashank Bharati</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=ashank96" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://dart.art/"><img src="https://avatars.githubusercontent.com/u/1755207?v=4?s=100" width="100px;" alt="Michael Chow"/><br /><sub><b>Michael Chow</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=chownation" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/RodXander"><img src="https://avatars.githubusercontent.com/u/23609784?v=4?s=100" width="100px;" alt="Osvaldo Saez"/><br /><sub><b>Osvaldo Saez</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=RodXander" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/rsydor"><img src="https://avatars.githubusercontent.com/u/79581663?v=4?s=100" width="100px;" alt="rsydor"/><br /><sub><b>rsydor</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=rsydor" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hoanglm4"><img src="https://avatars.githubusercontent.com/u/7067757?v=4?s=100" width="100px;" alt="Le Minh Hoang"/><br /><sub><b>Le Minh Hoang</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=hoanglm4" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Miiha"><img src="https://avatars.githubusercontent.com/u/3897167?v=4?s=100" width="100px;" alt="Michael Kao"/><br /><sub><b>Michael Kao</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Miiha" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cloudygeek"><img src="https://avatars.githubusercontent.com/u/6059542?v=4?s=100" width="100px;" alt="cloudygeek"/><br /><sub><b>cloudygeek</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=cloudygeek" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/chreck"><img src="https://avatars.githubusercontent.com/u/8030398?v=4?s=100" width="100px;" alt="Christoph Eck"/><br /><sub><b>Christoph Eck</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=chreck" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Ser1ous"><img src="https://avatars.githubusercontent.com/u/4497968?v=4?s=100" width="100px;" alt="Ser1ous"/><br /><sub><b>Ser1ous</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Ser1ous" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://spacelaunchnow.me/"><img src="https://avatars.githubusercontent.com/u/4519230?v=4?s=100" width="100px;" alt="Caleb Jones"/><br /><sub><b>Caleb Jones</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=ItsCalebJones" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://sungazer.io/"><img src="https://avatars.githubusercontent.com/u/6215122?v=4?s=100" width="100px;" alt="Saverio Murgia"/><br /><sub><b>Saverio Murgia</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=savy-91" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tranductam2802"><img src="https://avatars.githubusercontent.com/u/4957579?v=4?s=100" width="100px;" alt="Trần Đức Tâm"/><br /><sub><b>Trần Đức Tâm</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=tranductam2802" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://pcqpcq.me/"><img src="https://avatars.githubusercontent.com/u/1411571?v=4?s=100" width="100px;" alt="Joker"/><br /><sub><b>Joker</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=pcqpcq" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/ycv005/"><img src="https://avatars.githubusercontent.com/u/26734819?v=4?s=100" width="100px;" alt="Yash Chandra Verma"/><br /><sub><b>Yash Chandra Verma</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=ycv005" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/arneke"><img src="https://avatars.githubusercontent.com/u/425235?v=4?s=100" width="100px;" alt="Arne Kepp"/><br /><sub><b>Arne Kepp</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=arneke" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://omralcrt.github.io/"><img src="https://avatars.githubusercontent.com/u/12418327?v=4?s=100" width="100px;" alt="Ömral Cörüt"/><br /><sub><b>Ömral Cörüt</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=omralcrt" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/albatrosify"><img src="https://avatars.githubusercontent.com/u/64252708?v=4?s=100" width="100px;" alt="LrdHelmchen"/><br /><sub><b>LrdHelmchen</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=albatrosify" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://ungapps.com/"><img src="https://avatars.githubusercontent.com/u/8141036?v=4?s=100" width="100px;" alt="Steven Gunanto"/><br /><sub><b>Steven Gunanto</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=gunantosteven" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://schlau.bi/"><img src="https://avatars.githubusercontent.com/u/16060205?v=4?s=100" width="100px;" alt="Michael Rittmeister"/><br /><sub><b>Michael Rittmeister</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=DRSchlaubi" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://aakira.app/"><img src="https://avatars.githubusercontent.com/u/3386962?v=4?s=100" width="100px;" alt="Akira Aratani"/><br /><sub><b>Akira Aratani</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=AAkira" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Doflatango"><img src="https://avatars.githubusercontent.com/u/3091033?v=4?s=100" width="100px;" alt="Doflatango"/><br /><sub><b>Doflatango</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Doflatango" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Eddayy"><img src="https://avatars.githubusercontent.com/u/17043852?v=4?s=100" width="100px;" alt="Edmund Tay"/><br /><sub><b>Edmund Tay</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Eddayy" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://andreidiaconu.com/"><img src="https://avatars.githubusercontent.com/u/1402046?v=4?s=100" width="100px;" alt="Andrei Diaconu"/><br /><sub><b>Andrei Diaconu</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=andreidiaconu" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/plateaukao"><img src="https://avatars.githubusercontent.com/u/4084738?v=4?s=100" width="100px;" alt="Daniel Kao"/><br /><sub><b>Daniel Kao</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=plateaukao" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/xtyxtyx"><img src="https://avatars.githubusercontent.com/u/15033141?v=4?s=100" width="100px;" alt="xuty"/><br /><sub><b>xuty</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=xtyxtyx" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://bieker.ninja/"><img src="https://avatars.githubusercontent.com/u/818880?v=4?s=100" width="100px;" alt="Ben Bieker"/><br /><sub><b>Ben Bieker</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=wwwdata" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/phamnhuvu-dev"><img src="https://avatars.githubusercontent.com/u/22906656?v=4?s=100" width="100px;" alt="Phạm Như Vũ"/><br /><sub><b>Phạm Như Vũ</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=phamnhuvu-dev" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/SebastienBtr"><img src="https://avatars.githubusercontent.com/u/18089010?v=4?s=100" width="100px;" alt="SebastienBtr"/><br /><sub><b>SebastienBtr</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=SebastienBtr" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fattiger00"><img src="https://avatars.githubusercontent.com/u/38494401?v=4?s=100" width="100px;" alt="NeZha"/><br /><sub><b>NeZha</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=fattiger00" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/klydra"><img src="https://avatars.githubusercontent.com/u/40038209?v=4?s=100" width="100px;" alt="Jan Klinge"/><br /><sub><b>Jan Klinge</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=klydra" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/PauloDurrerMelo"><img src="https://avatars.githubusercontent.com/u/29310557?v=4?s=100" width="100px;" alt="PauloDurrerMelo"/><br /><sub><b>PauloDurrerMelo</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=PauloDurrerMelo" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/benmeemo"><img src="https://avatars.githubusercontent.com/u/47991706?v=4?s=100" width="100px;" alt="benmeemo"/><br /><sub><b>benmeemo</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=benmeemo" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cinos1"><img src="https://avatars.githubusercontent.com/u/19343437?v=4?s=100" width="100px;" alt="cinos"/><br /><sub><b>cinos</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=cinos1" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://xraph.com/"><img src="https://avatars.githubusercontent.com/u/11243590?v=4?s=100" width="100px;" alt="Rex Raphael"/><br /><sub><b>Rex Raphael</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=juicycleff" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Sense545"><img src="https://avatars.githubusercontent.com/u/769406?v=4?s=100" width="100px;" alt="Jan Henrik Høiland"/><br /><sub><b>Jan Henrik Høiland</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Sense545" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/igtm"><img src="https://avatars.githubusercontent.com/u/6331737?v=4?s=100" width="100px;" alt="Iguchi Tomokatsu"/><br /><sub><b>Iguchi Tomokatsu</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=igtm" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://uekoetter.dev/"><img src="https://avatars.githubusercontent.com/u/1270149?v=4?s=100" width="100px;" alt="Jonas Uekötter"/><br /><sub><b>Jonas Uekötter</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=ueman" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/emakar"><img src="https://avatars.githubusercontent.com/u/7767193?v=4?s=100" width="100px;" alt="emakar"/><br /><sub><b>emakar</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=emakar" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://weibo.com/magicrolan"><img src="https://avatars.githubusercontent.com/u/671431?v=4?s=100" width="100px;" alt="liasica"/><br /><sub><b>liasica</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=liasica" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/addie9000"><img src="https://avatars.githubusercontent.com/u/2036910?v=4?s=100" width="100px;" alt="Eiichiro Adachi"/><br /><sub><b>Eiichiro Adachi</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=addie9000" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/kamilpowalowski"><img src="https://avatars.githubusercontent.com/u/83073?v=4?s=100" width="100px;" alt="Kamil Powałowski"/><br /><sub><b>Kamil Powałowski</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=kamilpowalowski" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/akioyamamoto1977"><img src="https://avatars.githubusercontent.com/u/429219?v=4?s=100" width="100px;" alt="Akio Yamamoto"/><br /><sub><b>Akio Yamamoto</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=akioyamamoto1977" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mohenaxiba"><img src="https://avatars.githubusercontent.com/u/7977540?v=4?s=100" width="100px;" alt="mohenaxiba"/><br /><sub><b>mohenaxiba</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=mohenaxiba" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.acidic.co.nz"><img src="https://avatars.githubusercontent.com/u/1319813?v=4?s=100" width="100px;" alt="Ben Anderson"/><br /><sub><b>Ben Anderson</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=bagedevimo" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/daanporon"><img src="https://avatars.githubusercontent.com/u/71901?v=4?s=100" width="100px;" alt="Daan Poron"/><br /><sub><b>Daan Poron</b></sub></a><br /><a href="#security-daanporon" title="Security">🛡️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://yuki0311.com"><img src="https://avatars.githubusercontent.com/u/34892635?v=4?s=100" width="100px;" alt="ふぁ"/><br /><sub><b>ふぁ</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=fa0311" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/perffecto"><img src="https://avatars.githubusercontent.com/u/2116618?v=4?s=100" width="100px;" alt="perffecto"/><br /><sub><b>perffecto</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=perffecto" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/chandra-abdul-fattah"><img src="https://avatars.githubusercontent.com/u/16184998?v=4?s=100" width="100px;" alt="Chandra Abdul Fattah"/><br /><sub><b>Chandra Abdul Fattah</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=chandrabezzo" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.bebilica.rs/"><img src="https://avatars.githubusercontent.com/u/41632269?v=4?s=100" width="100px;" alt="Aleksandar Lugonja"/><br /><sub><b>Aleksandar Lugonja</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=LugonjaAleksandar" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.hera.cc"><img src="https://avatars.githubusercontent.com/u/534840?v=4?s=100" width="100px;" alt="Alexandre Richonnier"/><br /><sub><b>Alexandre Richonnier</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=heralight" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Sunbreak"><img src="https://avatars.githubusercontent.com/u/7928961?v=4?s=100" width="100px;" alt="Sunbreak"/><br /><sub><b>Sunbreak</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Sunbreak" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cslee"><img src="https://avatars.githubusercontent.com/u/590752?v=4?s=100" width="100px;" alt="Eric Lee"/><br /><sub><b>Eric Lee</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=cslee" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/KhatibFX"><img src="https://avatars.githubusercontent.com/u/5616640?v=4?s=100" width="100px;" alt="KhatibFX"/><br /><sub><b>KhatibFX</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=KhatibFX" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.guide.inc"><img src="https://avatars.githubusercontent.com/u/106543148?v=4?s=100" width="100px;" alt="Guide.inc"/><br /><sub><b>Guide.inc</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=guide-flutter" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Nirajn2311"><img src="https://avatars.githubusercontent.com/u/36357875?v=4?s=100" width="100px;" alt="Niraj Nandish"/><br /><sub><b>Niraj Nandish</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=Nirajn2311" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/nesquikm"><img src="https://avatars.githubusercontent.com/u/3867874?v=4?s=100" width="100px;" alt="nesquikm"/><br /><sub><b>nesquikm</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=nesquikm" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/andreasgangso"><img src="https://avatars.githubusercontent.com/u/727125?v=4?s=100" width="100px;" alt="Andreas Gangsø"/><br /><sub><b>Andreas Gangsø</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=andreasgangso" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/AlexT84"><img src="https://avatars.githubusercontent.com/u/80742383?v=4?s=100" width="100px;" alt="Alexandru Terente"/><br /><sub><b>Alexandru Terente</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=AlexT84" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/darkang3lz92"><img src="https://avatars.githubusercontent.com/u/33158127?v=4?s=100" width="100px;" alt="Dango Mango"/><br /><sub><b>Dango Mango</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=darkang3lz92" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://medium.com/@m-zimmermann1"><img src="https://avatars.githubusercontent.com/u/72440045?v=4?s=100" width="100px;" alt="Max Zimmermann"/><br /><sub><b>Max Zimmermann</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=maxmitz" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/alexandru-dochioiu/"><img src="https://avatars.githubusercontent.com/u/38853913?v=4?s=100" width="100px;" alt="Alexandru Dochioiu"/><br /><sub><b>Alexandru Dochioiu</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=AlexDochioiu" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/YumengNevix"><img src="https://avatars.githubusercontent.com/u/137131451?v=4?s=100" width="100px;" alt="YumengNevix"/><br /><sub><b>YumengNevix</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=YumengNevix" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/lrorpilla"><img src="https://avatars.githubusercontent.com/u/11363922?v=4?s=100" width="100px;" alt="lrorpilla"/><br /><sub><b>lrorpilla</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=lrorpilla" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/michalsrutek"><img src="https://avatars.githubusercontent.com/u/35694712?v=4?s=100" width="100px;" alt="Michal Šrůtek"/><br /><sub><b>Michal Šrůtek</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=michalsrutek" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/daisukeueta"><img src="https://avatars.githubusercontent.com/u/122339799?v=4?s=100" width="100px;" alt="daisukeueta"/><br /><sub><b>daisukeueta</b></sub></a><br /><a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=daisukeueta" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://jakebolam.com"><img src="https://avatars.githubusercontent.com/u/3534236?v=4?s=100" width="100px;" alt="Jake Bolam"/><br /><sub><b>Jake Bolam</b></sub></a><br /><a href="#infra-jakebolam" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-jakebolam" title="Maintenance">🚧</a> <a href="https://github.com/arrrrny/zikzak_inappwebview/commits?author=jakebolam" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification.

**YOUR NAME COULD BE HERE!** Contributions of any kind welcome!

</div>

---

<div align="center">

**Made with 💙 (and a healthy dose of caffeine) by the ZikZak Team**

⭐ **Star this repo if you believe in maintained open source!** ⭐

</div>
