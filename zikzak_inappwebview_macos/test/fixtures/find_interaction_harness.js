'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');

class EventTarget {
  constructor() {
    this.listeners = new Map();
  }

  addEventListener(type, callback, capture = false) {
    const listeners = this.listeners.get(type) || [];
    listeners.push({ callback, capture });
    this.listeners.set(type, listeners);
  }
}

class TextNode extends EventTarget {
  constructor(value) {
    super();
    this.nodeType = 3;
    this.nodeValue = String(value);
    this.parentNode = null;
  }

  deleteData(index, count) {
    this.nodeValue =
      this.nodeValue.slice(0, index) + this.nodeValue.slice(index + count);
  }

  get nextSibling() {
    if (!this.parentNode) return null;
    const siblings = this.parentNode.childNodes;
    return siblings[siblings.indexOf(this) + 1] || null;
  }
}

class DocumentFragment extends EventTarget {
  constructor() {
    super();
    this.nodeType = 11;
    this.childNodes = [];
    this.parentNode = null;
  }

  appendChild(child) {
    return this.insertBefore(child, null);
  }

  insertBefore(child, reference) {
    if (child === reference) return child;
    if (child.parentNode) child.parentNode.removeChild(child);
    const index = reference === null ? this.childNodes.length : this.childNodes.indexOf(reference);
    if (index < 0) throw new Error('Reference node is not a child');
    this.childNodes.splice(index, 0, child);
    child.parentNode = this;
    return child;
  }

  removeChild(child) {
    const index = this.childNodes.indexOf(child);
    if (index < 0) throw new Error('Node is not a child');
    this.childNodes.splice(index, 1);
    child.parentNode = null;
    return child;
  }

  get firstChild() {
    return this.childNodes[0] || null;
  }

  normalize() {
    for (let index = 0; index < this.childNodes.length; index++) {
      const child = this.childNodes[index];
      if (child.nodeType === 3) {
        let next = index + 1;
        while (next < this.childNodes.length && this.childNodes[next].nodeType === 3) {
          child.nodeValue += this.childNodes[next].nodeValue;
          this.removeChild(this.childNodes[next]);
        }
        if (child.nodeValue.length === 0) {
          this.removeChild(child);
          index--;
        }
      } else if (child.nodeType === 1) {
        child.normalize();
        if (child.shadowRoot) child.shadowRoot.normalize();
        if (child.nodeName === 'IFRAME' && child.contentDocument) {
          child.contentDocument.body.normalize();
        }
      }
    }
  }
}

class Element extends DocumentFragment {
  constructor(name) {
    super();
    this.nodeType = 1;
    this.nodeName = name.toUpperCase();
    this.style = { display: '', backgroundColor: '' };
    this.attributes = new Map();
    this.shadowRoot = null;
    this.contentDocument = null;
    this.scrolled = null;
  }

  getAttribute(name) {
    return this.attributes.get(name) || null;
  }

  setAttribute(name, value) {
    this.attributes.set(name, String(value));
  }

  scrollIntoView(options) {
    this.scrolled = options;
  }
}

class Document extends EventTarget {
  constructor() {
    super();
    this.nodeType = 9;
    this.body = new Element('body');
    this.body.parentNode = this;
    this.childNodes = [this.body];
  }

  createElement(name) {
    return new Element(name);
  }

  createTextNode(value) {
    return new TextNode(value);
  }

  dispatchScrollend() {
    for (const listener of this.listeners.get('scrollend') || []) {
      if (listener.capture) listener.callback({ type: 'scrollend' });
    }
  }
}

function createEnvironment(script) {
  const document = new Document();
  const messages = [];
  const timers = new Map();
  let nextTimerId = 1;

  const context = {
    console,
    document,
    setTimeout(callback, delay) {
      const id = nextTimerId++;
      timers.set(id, { callback, delay });
      return id;
    },
    clearTimeout(id) {
      timers.delete(id);
    },
  };
  context.window = context;
  context.webkit = {
    messageHandlers: {
      onFindResultReceived: {
        postMessage(message) {
          messages.push(JSON.parse(JSON.stringify(message)));
        },
      },
    },
  };

  vm.runInNewContext(script, context, { filename: 'FindInteractionJS.js' });
  return {
    bridge: context.zikzak_inappwebview,
    document,
    messages,
    timers,
    flushTimers() {
      const pending = Array.from(timers.values());
      timers.clear();
      for (const timer of pending) timer.callback();
    },
  };
}

function countHighlights(node, visited = new Set()) {
  if (!node || visited.has(node)) return 0;
  visited.add(node);
  let count = 0;
  if (node.nodeType === 1 && node.getAttribute('class') === 'zikzak_inappwebview_Highlight') {
    count++;
  }
  for (const child of node.childNodes || []) count += countHighlights(child, visited);
  if (node.shadowRoot) count += countHighlights(node.shadowRoot, visited);
  if (node.nodeName === 'IFRAME' && node.contentDocument) {
    count += countHighlights(node.contentDocument.body, visited);
  }
  return count;
}

function nestedRoots(script) {
  const env = createEnvironment(script);
  const host = env.document.createElement('div');
  env.document.body.appendChild(host);
  host.shadowRoot = new DocumentFragment();
  host.shadowRoot.appendChild(env.document.createTextNode('gemini shadow'));

  const iframe = env.document.createElement('iframe');
  env.document.body.appendChild(iframe);
  iframe.contentDocument = new Document();
  iframe.contentDocument.body.appendChild(env.document.createTextNode('openai frame'));

  env.bridge._findAllAsync('gemini');
  assert.equal(env.messages.at(-1).numberOfMatches, 1);
  assert.equal(countHighlights(host.shadowRoot), 1);
  assert.equal(countHighlights(iframe.contentDocument.body), 0);

  env.bridge._findAllAsync('openai');
  assert.equal(env.messages.at(-1).numberOfMatches, 1);
  assert.equal(countHighlights(host.shadowRoot), 0);
  assert.equal(countHighlights(iframe.contentDocument.body), 1);
  assert.equal(env.messages.length, 2);
}

function failedWalk(script) {
  const env = createEnvironment(script);
  env.document.body.appendChild(env.document.createTextNode('gemini gemini'));
  const createTextNode = env.document.createTextNode.bind(env.document);
  let calls = 0;
  env.document.createTextNode = (value) => {
    calls++;
    if (calls === 4) throw new Error('detached parent');
    return createTextNode(value);
  };

  let failure;
  try {
    env.bridge._findAllAsync('gemini');
  } catch (error) {
    failure = error;
  }

  assert.equal(failure && failure.message, 'detached parent');
  assert.equal(env.messages.length, 1);
  assert.deepEqual(env.messages[0], {
    activeMatchOrdinal: 0,
    numberOfMatches: 1,
    isDoneCounting: true,
  });
  assert.equal(env.bridge._highlightNodes.length, 1);
}

function missingHighlight(script) {
  const env = createEnvironment(script);
  env.document.body.appendChild(env.document.createTextNode('gemini gemini'));
  env.bridge._findAllAsync('gemini');
  env.messages.length = 0;
  env.bridge._highlightNodes[1] = null;

  let failure;
  try {
    env.bridge._findNext(true);
  } catch (error) {
    failure = error;
  }

  assert.equal(env.messages.length, 1);
  assert.deepEqual(env.messages[0], {
    activeMatchOrdinal: 1,
    numberOfMatches: 2,
    isDoneCounting: true,
  });
  assert.equal(failure, undefined);
  assert.equal(env.bridge._currentHighlight, 1);
}

function zeroMatchNavigation(script) {
  const env = createEnvironment(script);
  env.document.body.appendChild(env.document.createTextNode('alpha'));
  env.bridge._findAllAsync('gemini');
  env.messages.length = 0;

  env.bridge._findNext(true);

  assert.equal(env.messages.length, 1);
  assert.deepEqual(env.messages[0], {
    activeMatchOrdinal: 0,
    numberOfMatches: 0,
    isDoneCounting: true,
  });
  assert.equal(env.bridge._currentHighlight, 0);
}

function scrollendRescan(script) {
  const env = createEnvironment(script);
  env.document.body.appendChild(env.document.createTextNode('gemini'));
  env.bridge._findAllAsync('GeMiNi');
  env.messages.length = 0;

  env.document.body.appendChild(env.document.createTextNode(' gemini'));
  env.document.dispatchScrollend();
  env.document.dispatchScrollend();
  assert.equal(env.timers.size, 1);

  env.flushTimers();

  assert.equal(env.messages.length, 1);
  assert.deepEqual(env.messages[0], {
    activeMatchOrdinal: 0,
    numberOfMatches: 2,
    isDoneCounting: true,
  });
  assert.equal(env.bridge._highlightNodes.length, 2);
  assert.equal(env.timers.size, 0);
}

function clearCancelsRescan(script) {
  const env = createEnvironment(script);
  env.document.body.appendChild(env.document.createTextNode('gemini'));
  env.bridge._findAllAsync('gemini');
  env.messages.length = 0;

  env.document.dispatchScrollend();
  assert.equal(env.timers.size, 1);
  env.bridge._clearMatches();
  assert.equal(env.timers.size, 0);
  assert.equal(env.bridge._activeFindKeyword, '');

  env.document.body.appendChild(env.document.createTextNode(' gemini'));
  env.document.dispatchScrollend();
  assert.equal(env.timers.size, 0);
  env.flushTimers();
  assert.equal(env.messages.length, 0);
}

const scenarios = {
  'nested-roots': nestedRoots,
  'failed-walk': failedWalk,
  'missing-highlight': missingHighlight,
  'zero-match-navigation': zeroMatchNavigation,
  'scrollend-rescan': scrollendRescan,
  'clear-cancels-rescan': clearCancelsRescan,
};
const [scriptPath, scenario] = process.argv.slice(2);
assert.ok(scriptPath, 'finder script path is required');
assert.ok(scenarios[scenario], `unknown scenario: ${scenario}`);
scenarios[scenario](fs.readFileSync(scriptPath, 'utf8'));
console.log(`OK ${scenario}`);
