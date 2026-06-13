import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Reproduction demo for issue #144 (Issue 2: progress stuck at 80%).
///
/// Key points: there need to be two stacked InAppWebView.
/// Operation steps:
///   Home Page -> Page A -> Page B -> Back to Page A -> Page B
///   (it will get stuck in the loading state at this point)
class WebViewDemoHomePage extends StatelessWidget {
  const WebViewDemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView Demo - Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WebViewDemoFirstPage(),
                  ),
                );
              },
              child: const Text('To Page A'),
            ),
            const SizedBox(height: 16),
            Text(
              'Step 1: Tap "To Page A"\n'
              'Step 2: On Page A, tap "To Page B"\n'
              'Step 3: On Page B, tap Back\n'
              'Step 4: Tap "To Page B" again\n'
              'Expected: Page B loads fine\n'
              'Bug: Page B gets stuck loading',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====================== Page A =======================
class WebViewDemoFirstPage extends StatefulWidget {
  const WebViewDemoFirstPage({super.key});

  @override
  State<WebViewDemoFirstPage> createState() => _WebViewDemoFirstPageState();
}

class _WebViewDemoFirstPageState extends State<WebViewDemoFirstPage> {
  static const String _localHtml = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>A 页</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "PingFang SC", sans-serif;
      background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
      color: #fff;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
    }
    .card {
      background: rgba(255,255,255,0.15);
      -webkit-backdrop-filter: blur(10px);
      backdrop-filter: blur(10px);
      border-radius: 16px;
      padding: 32px 24px;
      text-align: center;
      max-width: 360px;
      width: 100%;
    }
    h1 { font-size: 22px; margin-bottom: 8px; }
    p  { line-height: 1.6; opacity: .9; margin-bottom: 24px; }
    button {
      width: 100%;
      padding: 12px 20px;
      border: none;
      border-radius: 10px;
      background: #fff;
      color: #185a9d;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
    }
    button:active { opacity: .85; }
  </style>
</head>
<body>
  <div class="card">
    <h1> Page A </h1>
  </div>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page A')),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialData: InAppWebViewInitialData(data: _localHtml),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                // useHybridComposition: true,
              ),
              onLoadStart: (controller, url) {
                debugPrint('A.onLoadStart: $url');
              },
              onLoadStop: (controller, url) {
                debugPrint('A.onLoadStop: $url');
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _gotoB,
                  child: const Text('To Page B'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _gotoB() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const WebViewDemoSecondPage(),
      ),
    );
  }
}

/// ====================== Page B =======================
class WebViewDemoSecondPage extends StatefulWidget {
  const WebViewDemoSecondPage({super.key});

  @override
  State<WebViewDemoSecondPage> createState() => _WebViewDemoSecondPageState();
}

class _WebViewDemoSecondPageState extends State<WebViewDemoSecondPage> {
  bool _showLoading = false;

  static const String _localHtml = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover">
<meta name="referrer" content="no-referrer">
<meta name="theme-color" content="#000000">
    <title>笔记</title><style>
* { margin: 0; padding: 0; box-sizing: border-box; }
html, body {
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "PingFang SC", "Helvetica Neue", sans-serif;
  background: #f5f6fa;
  color: #1a1a2e;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  -webkit-user-select: none; user-select: none;
  -webkit-touch-callout: none;
  overscroll-behavior: none;
  width: 100%;
  min-height: 100vh;
  min-height: -webkit-fill-available;
}
::-webkit-scrollbar { width: 0; height: 0; }

.page-wrapper {
  padding: 40px 20px 40px;
  width: 100%;
  max-width: 480px;
  margin: 0 auto;
}

/* ===== Book Info Card ===== */

.book-info-card {
  background: linear-gradient(135deg, #e8e4f8, #ddd6f3);
  border-radius: 16px;
  padding: 16px 18px;
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 14px;
  animation: fadeUp .4s ease-out .1s both;
  border: 1px solid rgba(99, 102, 241, 0.15);
}
.book-info-cover {
  width: 48px;
  height: 64px;
  border-radius: 8px;
  object-fit: cover;
  background: #e0e0e0;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.book-info-cover-fallback {
  width: 48px;
  height: 64px;
  border-radius: 8px;
  background: #e8e8e8;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  color: #999;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
.book-info-text { flex: 1; min-width: 0; }
.book-info-title {
  font-size: 16px;
  font-weight: 600;
  color: #1a1a2e;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.book-info-author {
  font-size: 13px;
  color: #888;
  margin-top: 2px;
}

/* ===== Form ===== */
.form-group {
  margin-bottom: 20px;
  animation: fadeUp .4s ease-out both;
}
.form-group:nth-child(1) { animation-delay: .15s; }
.form-group:nth-child(2) { animation-delay: .2s; }
.form-group:nth-child(3) { animation-delay: .25s; }

.form-label {
  display: block;
  font-size: 14px;
  font-weight: 600;
  color: #444;
  margin-bottom: 8px;
}
.form-label .required { color: #e53935; margin-left: 2px; }

.form-textarea {
  width: 100%;
  min-height: 140px;
  padding: 14px 16px;
  border: 2px solid #e8e8f0;
  border-radius: 14px;
  font-size: 15px;
  font-family: inherit;
  color: #1a1a2e;
  background: #fff;
  resize: vertical;
  transition: border-color .25s, box-shadow .25s;
  -webkit-appearance: none;
  outline: none;
  line-height: 1.6;
}
.form-textarea:focus {
  border-color: #000;
  box-shadow: 0 0 0 4px rgba(0,0,0,0.08);
}
.form-textarea::placeholder { color: #bbb; }

.form-input {
  width: 100%;
  height: 48px;
  padding: 0 16px;
  border: 2px solid #e8e8f0;
  border-radius: 14px;
  font-size: 15px;
  font-family: inherit;
  color: #1a1a2e;
  background: #fff;
  transition: border-color .25s, box-shadow .25s;
  -webkit-appearance: none;
  outline: none;
}
.form-input:focus {
  border-color: #000;
  box-shadow: 0 0 0 4px rgba(0,0,0,0.08);
}
.form-input::placeholder { color: #bbb; }
.form-input[type="date"] { padding-right: 8px; }

.char-count {
  text-align: right;
  font-size: 12px;
  color: #aaa;
  margin-top: 4px;
  padding-right: 4px;
}

/* ===== Submit Button ===== */
.submit-btn {
  width: 100%;
  height: 52px;
  border: none;
  border-radius: 16px;
  background: #000;
  color: #fff;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
  transition: all .3s;
  margin-top: 12px;
  animation: fadeUp .4s ease-out .3s both;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.25);
}
.submit-btn:active { transform: scale(0.97); opacity: 0.9; }
.submit-btn:disabled {
  opacity: 0.5;
  transform: none;
  box-shadow: none;
}

.delete-btn {
  width: 100%;
  height: 52px;
  border: 2px solid #e53935;
  border-radius: 16px;
  background: #fff;
  color: #e53935;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
  transition: all .3s;
  margin-top: 12px;
  animation: fadeUp .4s ease-out .35s both;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}
.delete-btn:active { transform: scale(0.97); opacity: 0.8; }

/* ===== Toast ===== */
.toast {
  position: fixed;
  bottom: 80px;
  left: 50%;
  transform: translateX(-50%) translateY(20px);
  background: rgba(0,0,0,0.8);
  -webkit-backdrop-filter: blur(10px);
  backdrop-filter: blur(10px);
  color: #fff;
  padding: 12px 24px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 500;
  opacity: 0;
  transition: all .35s cubic-bezier(0.4,0,0.2,1);
  z-index: 100;
  pointer-events: none;
  white-space: nowrap;
}
.toast.show {
  opacity: 1;
  transform: translateX(-50%) translateY(0);
}

/* ===== Loading ===== */
.loading-overlay {
  position: fixed;
  inset: 0;
  background: rgba(255,255,255,0.7);
  -webkit-backdrop-filter: blur(4px);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 200;
  opacity: 0;
  pointer-events: none;
  transition: opacity .3s;
}
.loading-overlay.show { opacity: 1; pointer-events: auto; }
.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #e8e8f0;
  border-top-color: #000;
  border-radius: 50%;
  animation: spin .7s linear infinite;
}

@keyframes fadeDown { from { opacity: 0; transform: translateY(-12px); } to { opacity: 1; transform: translateY(0); } }
@keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
@keyframes spin { to { transform: rotate(360deg); } }
</style>
</head>
<body>

<div class="loading-overlay" id="loadingOverlay"><div class="loading-spinner"></div></div>

<div class="page-wrapper">
  <!-- Book Info -->
  <div class="book-info-card" id="bookInfoCard">
    <img class="book-info-cover" id="bookCover" src="" alt="封面" style="display:none">
    <div class="book-info-cover-fallback" id="coverFallback" style="display:flex">📖</div>
    <div class="book-info-text">
      <div class="book-info-title" id="bookTitle">—</div>
      <div class="book-info-author" id="bookAuthor">—</div>
    </div>
  </div>

  <!-- Form -->
  <div class="form-group">
    <label class="form-label">笔记内容 <span class="required">*</span></label>
    <textarea class="form-textarea" id="noteContent" placeholder="写下你的读书感悟、摘抄或思考…" maxlength="2000"></textarea>
    <div class="char-count"><span id="charCount">0</span> / 2000</div>
  </div>

  <div class="form-group">
    <label class="form-label">进度页码 <span class="required">*</span></label>
    <input class="form-input" id="pageNumber" type="number" placeholder="如：120" min="0">
  </div>

  <div class="form-group">
    <label class="form-label">日期</label>
    <input class="form-input" id="noteDate" type="date">
  </div>

  <button class="submit-btn" id="submitBtn">
    <span>✓</span> 保存笔记
  </button>
  <button class="delete-btn" id="deleteBtn" style="display:none">
    <span>🗑</span> 删除笔记
  </button>
</div>

<div class="toast" id="toast"></div>

<script>
// ===== Constants =====
var NOTE_TABLE = 'iPGHfYXoT5IT';
var BOOK_TABLE = 'Up24N8w8bOVd';
var COL_CONTENT = '_AdSqBmIsl6DWgQv';
var COL_PAGE = 'cznjo4AMMrJWZHsq';
var COL_BOOK = 'D5cXb3l6OdfDYBgp';
var COL_TIME = 'UTrnPIblqAliiz1U';

// ===== State =====
var gBook = null;
var gNote = null;
var isSubmitting =false;
var isEditMode =false;

// ===== DOM =====
var noteContent = document.getElementById('noteContent');
var pageNumber = document.getElementById('pageNumber');
var noteDate = document.getElementById('noteDate');
var submitBtn = document.getElementById('submitBtn');
var toast = document.getElementById('toast');
var loadingOverlay = document.getElementById('loadingOverlay');
var charCount = document.getElementById('charCount');

// ===== Init =====
function init() {
  var ctx = window.gridea.routeContext;
  var input = (ctx && ctx.input) || {};
  var bookUid = input.book_uid || null;
  var noteUid = input.note_uid || null;
  if (!bookUid && !noteUid) {
    showToast('缺少书籍信息');
    return;
  }
  if (noteUid) {
    isEditMode = true;
    loadNote(noteUid);
  } else {
    loadBook(bookUid);
    setDefaultDate();
  }
  setupEvents();
}

function setDefaultDate() {
  var now = new Date();
  var y = now.getFullYear();
  var m = String(now.getMonth() + 1).padStart(2, '0');
  var d = String(now.getDate()).padStart(2, '0');
  noteDate.value = y + '-' + m + '-' + d;
}

async function loadBook(bookUid) {
  try {
    loadingOverlay.classList.add('show');
    var sql = 'SELECT * FROM "rows_' + BOOK_TABLE + '" WHERE "uid" = \\'' + bookUid + '\\'';
    var rows = await window.gridea.query_rows(sql);
    if (!rows || rows.length === 0) {
      showToast('未找到书籍信息');
      return;
    }
    gBook = rows[0];
    document.getElementById('bookTitle').textContent = gBook.xWHsIieeAvM28JHR || '未命名';
    document.getElementById('bookAuthor').textContent = gBook.BVmCKyP3fZnn3yrz || '未知作者';
    var cover = gBook.ZoW1mlFPL4Ms0LIO;
    if (cover) {
      try {
        var covers = JSON.parse(cover);
        if (covers && covers.length > 0) {
          setCoverImage(covers[0]);
        } else {
          showCoverFallback();
        }
      } catch(e) {
        setCoverImage(cover);
      }
    } else {
      showCoverFallback();
    }
  } catch (e) {
    console.error(e);
    showToast('加载书籍信息失败');
  } finally {
    loadingOverlay.classList.remove('show');
  }
}

async function loadNote(noteUid) {
  try {
    loadingOverlay.classList.add('show');
    var sql = 'SELECT * FROM "rows_' + NOTE_TABLE + '" WHERE "uid" = \\'' + noteUid + '\\'';
    var rows = await window.gridea.query_rows(sql);
    if (!rows || rows.length === 0) {
      showToast('未找到笔记');
      return;
    }
    gNote = rows[0];
    // Load associated book
    var bookLink = gNote[COL_BOOK];
    if (bookLink) {
      try {
        var linkObj = JSON.parse(bookLink);
        var bookUids = Object.keys(linkObj);
        if (bookUids.length > 0) {
          await loadBook(bookUids[0]);
        }
      } catch(e) {
        console.error(e);
      }
    }
    // Pre-fill form
    noteContent.value = gNote[COL_CONTENT] || '';
    charCount.textContent = noteContent.value.length;
    pageNumber.value = gNote[COL_PAGE] || '';
    if (gNote[COL_TIME]) {
      var ts = gNote[COL_TIME];
      if (typeof ts === 'number') {
        var d = new Date(ts * 1000);
        var y = d.getFullYear();
        var m = String(d.getMonth() + 1).padStart(2, '0');
        var day = String(d.getDate()).padStart(2, '0');
        noteDate.value = y + '-' + m + '-' + day;
      }
    } else {
      setDefaultDate();
    }
    // Update UI for edit mode
    submitBtn.innerHTML = '<span>✓</span> 更新笔记';
    document.getElementById('deleteBtn').style.display = 'flex';
  } catch (e) {
    console.error(e);
    showToast('加载笔记失败');
  } finally {
    loadingOverlay.classList.remove('show');
  }
}

function setupEvents() {
  noteContent.addEventListener('input', function() {
    charCount.textContent = this.value.length;
  });

  submitBtn.addEventListener('click', submitNote);
  document.getElementById('deleteBtn').addEventListener('click', deleteNote);
}

// ===== Submit =====
async function submitNote() {
  if (isSubmitting) return;
  var content = noteContent.value.trim();
  if (!content) {
    showToast('请输入笔记内容');
    noteContent.focus();
    return;
  }
  var pageVal = pageNumber.value.trim();
  if (!pageVal) {
    showToast('请输入进度页码');
    pageNumber.focus();
    return;
  }
  if (!gBook) {
    showToast('书籍信息未加载');
    return;
  }

  isSubmitting =true;
  submitBtn.disabled =true;
  submitBtn.innerHTML = '<div class="loading-spinner" style="width:20px;height:20px;border-width:2px;border-top-color:#fff;border-color:rgba(255,255,255,0.3);border-top-color:#fff;"></div> 保存中…';

  try {
    var dateVal = noteDate.value;

    var cells = {};
    cells[COL_CONTENT] = content;
    cells[COL_PAGE] = parseFloat(pageVal);
    if (dateVal) {
      var d = new Date(dateVal + 'T00:00:00');
      cells[COL_TIME] = Math.floor(d.getTime() / 1000);
    }
    cells[COL_BOOK] = [gBook.uid];

    if (isEditMode && gNote) {
      await window.gridea.update_row(NOTE_TABLE, gNote.uid, cells);
      showToast('✅ 笔记已更新');
      setTimeout(function() {
        window.gridea.popPage({ type: 'updated', rowUid: gNote.uid });
      }, 400);
    } else {
      var row = await window.gridea.create_row(NOTE_TABLE, cells);
      if (row && row.uid) {
        showToast('✅ 笔记已添加');
        setTimeout(function() {
          window.gridea.popPage({ type: 'created', rowUid: row.uid });
        }, 400);
      }
    }
  } catch (e) {
    console.error(e);
    showToast('保存失败，请重试');
    isSubmitting =false;
    submitBtn.disabled =false;
    submitBtn.innerHTML = isEditMode ? '<span>✓</span> 更新笔记' : '<span>✓</span> 保存笔记';
  }
}

// ===== Delete =====
async function deleteNote() {
  if (!gNote) return;
  if (!confirm('确定要删除这条笔记吗？')) return;
  try {
    loadingOverlay.classList.add('show');
    await window.gridea.delete_row(NOTE_TABLE, gNote.uid);
    showToast('✅ 笔记已删除');
    setTimeout(function() {
      window.gridea.popPage({ type: 'deleted', rowUid: gNote.uid });
    }, 400);
  } catch (e) {
    console.error(e);
    showToast('删除失败');
    loadingOverlay.classList.remove('show');
  }
}

// ===== Cover Image =====
function setCoverImage(url) {
  var img = document.getElementById('bookCover');
  var fallback = document.getElementById('coverFallback');
  if (!img) return;
  img.onerror = function() {
    img.style.display = 'none';
    if (fallback) fallback.style.display = 'flex';
  };
  img.onload = function() {
    img.style.display = 'block';
    if (fallback) fallback.style.display = 'none';
  };
  img.src = url;
}
function showCoverFallback() {
  var img = document.getElementById('bookCover');
  var fallback = document.getElementById('coverFallback');
  if (img) img.style.display = 'none';
  if (fallback) fallback.style.display = 'flex';
}

// ===== Toast =====
var toastTimer = null;
function showToast(msg) {
  toast.textContent = msg;
  toast.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(function() {
    toast.classList.remove('show');
  }, 2200);
}

// ===== Init =====
document.addEventListener('DOMContentLoaded', init);
</script>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page B')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        InAppWebView(
          initialData: InAppWebViewInitialData(data: _localHtml),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            // useHybridComposition: true,
          ),
          onLoadStart: (controller, url) {
            debugPrint('B.onLoadStart: $url');
            setState(() => _showLoading = true);
          },
          onLoadStop: (controller, url) {
            debugPrint('B.onLoadStop: $url');
            setState(() => _showLoading = false);
          },
        ),
        if (_showLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
