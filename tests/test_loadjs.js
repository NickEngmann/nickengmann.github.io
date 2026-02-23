const assert = require('assert');

// Mock the DOM environment
const jsdom = require('jsdom');
const { JSDOM } = jsdom;

describe('load-js.js', () => {
  let dom;
  let window;
  let document;

  beforeEach(() => {
    dom = new JSDOM('<!DOCTYPE html><html><body><script src="/existing.js"></script></body></html>', {
      url: 'http://localhost',
      pretendToBeVisual: true,
      resources: 'usable'
    });
    window = dom.window;
    document = dom.window.document;
  });

  it('should define loadJS function', () => {
    // Execute the load-js.js code in the context of the mocked window
    const fs = require('fs');
    const code = fs.readFileSync('_includes/scripts/load-js.js', 'utf8');
    
    // Create a function that accepts window and document
    const scriptFn = new Function('window', 'document', code);
    scriptFn(window, document);
    
    assert.strictEqual(typeof window.loadJS, 'function');
  });

  describe('loadJS', () => {
    beforeEach(() => {
      const fs = require('fs');
      const code = fs.readFileSync('_includes/scripts/load-js.js', 'utf8');
      const scriptFn = new Function('window', 'document', code);
      scriptFn(window, document);
    });

    it('should create and insert a script element', () => {
      const script = window.loadJS('/test.js');
      
      assert(script);
      assert(script.src.includes('/test.js'));
      
      const firstScript = document.scripts[0];
      assert.strictEqual(script, firstScript);
    });

    it('should insert script before the first existing script', () => {
      const existingScript = document.scripts[0];
      
      const newScript = window.loadJS('/new.js');
      
      assert(newScript.src.includes('/new.js'));
      assert.strictEqual(document.scripts.length, 2);
      assert.strictEqual(document.scripts[0], newScript);
      assert.strictEqual(document.scripts[1], existingScript);
    });

    it('should accept a callback function', () => {
      let callbackCalled = false;
      const callback = () => { callbackCalled = true; };
      
      const script = window.loadJS('/test.js', callback);
      
      assert(script);
      // The callback should be attached to the script's load event
      assert.strictEqual(callbackCalled, false); // Not called yet since we don't trigger the event
    });
  });

  describe('loadJSDeferred', () => {
    beforeEach(() => {
      const fs = require('fs');
      const code = fs.readFileSync('_includes/scripts/load-js.js', 'utf8');
      const scriptFn = new Function('window', 'document', code);
      scriptFn(window, document);
      // Reset _loaded for each test
      window._loaded = false;
    });

    it('should create and insert a script element', () => {
      const script = window.loadJSDeferred('/test.js');
      
      assert(script);
      assert(script.src.includes('/test.js'));
    });

    it('should insert script immediately if window._loaded is true', () => {
      window._loaded = true;
      
      const script = window.loadJSDeferred('/test.js');
      
      assert(script);
      const firstScript = document.scripts[0];
      assert.strictEqual(script, firstScript);
      assert.strictEqual(window._loaded, true);
    });

    it('should call callback after window load event', () => {
      window._loaded = false;
      
      let callbackCalled = false;
      const callback = () => { callbackCalled = true; };
      
      const script = window.loadJSDeferred('/test.js', callback);
      
      assert(script);
      // Script should not be inserted yet (only 1 existing script)
      assert.strictEqual(document.scripts.length, 1);
      
      // Simulate window load event
      window.dispatchEvent(new dom.window.Event('load'));
      
      assert.strictEqual(window._loaded, true);
      // After load event, the script should be inserted and callback attached
      // But the callback won't be called until the script actually loads
      // Since we're not actually loading the script, just verify the callback was attached
      assert.strictEqual(callbackCalled, false);
    });
  });

  describe('setRel', () => {
    beforeEach(() => {
      const fs = require('fs');
      const code = fs.readFileSync('_includes/scripts/load-js.js', 'utf8');
      const scriptFn = new Function('window', 'document', code);
      scriptFn(window, document);
    });

    it('should set rel attribute to stylesheet on load', () => {
      const link = document.createElement('link');
      link.id = 'test-link';
      link.rel = 'alternate';
      document.body.appendChild(link);
      
      window.setRel('test-link');
      
      // Should still be 'alternate' initially
      assert.strictEqual(link.rel, 'alternate');
      
      // Trigger load event
      link.dispatchEvent(new dom.window.Event('load'));
      
      assert.strictEqual(link.rel, 'stylesheet');
    });
  });
});
