(function () {
  // Guard: only run on .amap files (match pattern covers all file:// URLs)
  if (!location.pathname.endsWith('.amap')) return;

  // Chrome renders plain-text files in a <pre>; grab it or fall back to body
  let pre = document.querySelector('pre');
  if (!pre) {
    const text = document.body && document.body.textContent;
    if (!text || !text.trim()) return;
    document.body.innerHTML = '<pre></pre>';
    pre = document.querySelector('pre');
    pre.textContent = text;
  }

  const raw = pre.textContent;

  function esc(s) {
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }

  function sp(cls, s) {
    return `<span class="am-${cls}">${s}</span>`;
  }

  function highlightLine(line) {
    if (/^\s*={3}.+={3}\s*$/.test(line))           return sp('section', esc(line));
    if (/^CITATIONS\s*$/.test(line))                return sp('section', esc(line));
    if (/^\s*(entry|exit|zoom)\s*[↓:]/.test(line)) return sp('meta',    esc(line));
    if (/^\s*#/.test(line))                         return sp('comment', esc(line));
    return tokenize(line, /^\s*↓/.test(line));
  }

  const BASE_RULES = [
    [/^\[([^\]]*)\]/,  m => sp('state',  esc('[') + stateInner(m[1]) + esc(']'))],
    [/^↓/,             m => sp('arrow',  esc(m[0]))],
    [/^⊗/,             m => sp('tensor', esc(m[0]))],
    [/^\(!\)/,         m => sp('naked',  esc(m[0]))],
    [/^\(E\)/,         m => sp('lit-e',  esc(m[0]))],
    [/^\(T\)/,         m => sp('lit-t',  esc(m[0]))],
    [/^\(R\)/,         m => sp('lit-r',  esc(m[0]))],
    [/^"[^"]*"/,       m => sp('note',   esc(m[0]))],
  ];

  const STATUS_RULES = [
    [/^\?/, m => sp('stub',     esc(m[0]))],
    [/^~/,  m => sp('drafted',  esc(m[0]))],
    [/^\*/, m => sp('cited',    esc(m[0]))],
    [/^✓/,  m => sp('complete', esc(m[0]))],
  ];

  function tokenize(line, isClaimLine) {
    const rules = isClaimLine
      ? [BASE_RULES[0], BASE_RULES[1], ...STATUS_RULES, ...BASE_RULES.slice(2)]
      : BASE_RULES;

    let result = '';
    let i = 0;
    while (i < line.length) {
      const rest = line.slice(i);
      let matched = false;
      for (const [re, fn] of rules) {
        const m = rest.match(re);
        if (m) {
          result += fn(m);
          i += m[0].length;
          matched = true;
          break;
        }
      }
      if (!matched) {
        result += esc(line[i++]);
      }
    }
    return result;
  }

  function stateInner(inner) {
    return inner.split('⊗').map(esc).join(sp('tensor', '⊗'));
  }

  pre.innerHTML = raw.split('\n').map(highlightLine).join('\n');
})();
