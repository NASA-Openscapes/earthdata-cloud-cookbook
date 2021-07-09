window.document.addEventListener("DOMContentLoaded", function (event) {
  const disableEls = (els) => {
    for (let i=0; i < els.length; i++) {
      const el = els[i];
      el.disabled = true;
    }
  }
  const enableEls = (els) => {
    for (let i=0; i < els.length; i++) {
      const el = els[i];
      el.removeAttribute("disabled");
    }
  }
  const manageTransitions = (selector, allowTransitions) => {
    const els = window.document.querySelectorAll(selector);
    for (let i=0; i < els.length; i++) {
      const el = els[i];
      if (allowTransitions) {
        el.classList.remove('notransition');
      } else {
        el.classList.add('notransition');
      }
    }
  }
  const toggleColorMode = (dark) => {
    const toggles = window.document.querySelectorAll('.quarto-color-scheme-toggle');
    for (let i=0; i < toggles.length; i++) {
      const toggle = toggles[i];
      if (toggle) {
        const lightEls = window.document.querySelectorAll('link.quarto-color-scheme.light');
        const darkEls = window.document.querySelectorAll('link.quarto-color-scheme.dark');
        manageTransitions('div.sidebar-toc .nav-link', false);
        if (dark) {
          enableEls(darkEls);
          disableEls(lightEls);
          toggle.classList.remove("light");
          toggle.classList.add("dark");     
        } else {
          enableEls(lightEls);
          disableEls(darkEls);
          toggle.classList.remove("dark");
          toggle.classList.add("light");
        }
        manageTransitions('.quarto-toc-sidebar .nav-link', true);
      }
    }
  }
  const isFileUrl = () => { 
    return window.location.protocol === 'file:';
  }
  const hasDarkSentinel = () => {  
    let darkSentinel = getDarkSentinel();
    if (darkSentinel !== null) {
      return darkSentinel === "dark";
    } else {
      return false;
    }
  }
  const setDarkSentinel = (toDark) => {
    const value = toDark ? "dark" : "light";
    if (!isFileUrl()) {
      window.localStorage.setItem("quarto-color-scheme", value);
    } else {
      localDarkSentinel = value;
    }
  }
  const getDarkSentinel = () => {
    if (!isFileUrl()) {
      return window.localStorage.getItem("quarto-color-scheme");
    } else {
      return localDarkSentinel;
    }
  }
  let localDarkSentinel = null;
  // Dark / light mode switch
  window.quartoToggleColorScheme = () => {
    // Read the current dark / light value 
    let toDark = !hasDarkSentinel();
    toggleColorMode(toDark);
    setDarkSentinel(toDark);
  };
  // Ensure there is a toggle, if there isn't float one in the top right
  if (window.document.querySelector('.quarto-color-scheme-toggle') === null) {
    const a = window.document.createElement('a');
    a.id = "quarto-color-scheme-toggle";
    a.classList.add('top-right');
    a.href = "";
    a.onclick = function() { window.quartoToggleColorScheme(); return false; };
    const i = window.document.createElement("i");
    i.classList.add('bi');
    a.appendChild(i);
    window.document.body.appendChild(a);
  }
  // Switch to dark mode if need be
  if (hasDarkSentinel()) {
    toggleColorMode(true);
  } 
  const icon = "";
  const anchorJS = new window.AnchorJS();
  anchorJS.options = {
    placement: 'right',
    icon: icon
  };
  anchorJS.add('.anchored');
  const clipboard = new window.ClipboardJS('.code-copy-button', {
    target: function(trigger) {
      return trigger.previousElementSibling;
    }
  });
  clipboard.on('success', function(e) {
    // button target
    const button = e.trigger;
    // don't keep focus
    button.blur();
    // flash "checked"
    button.classList.add('code-copy-button-checked');
    setTimeout(function() {
      button.classList.remove('code-copy-button-checked');
    }, 1000);
    // clear code selection
    e.clearSelection();
  });
  function tippyHover(el, contentFn) {
    window.tippy(el, {
      allowHTML: true,
      content: contentFn,
      maxWidth: 500,
      delay: 100,
      interactive: true,
      interactiveBorder: 10,
      theme: 'quarto',
      placement: 'bottom-start'
    }); 
  }
  const noterefs = window.document.querySelectorAll('a[role="doc-noteref"]');
  for (var i=0; i<noterefs.length; i++) {
    const ref = noterefs[i];
    tippyHover(ref, function() {
      const id = new URL(ref.getAttribute('href')).hash.replace(/^#/, "");
      const note = window.document.getElementById(id);
      return note.innerHTML;
    });
  }
  var bibliorefs = window.document.querySelectorAll('a[role="doc-biblioref"]');
  for (var i=0; i<bibliorefs.length; i++) {
    const ref = bibliorefs[i];
    const cites = ref.parentNode.getAttribute('data-cites').split(' ');
    tippyHover(ref, function() {
      var popup = window.document.createElement('div');
      cites.forEach(function(cite) {
        var citeDiv = window.document.createElement('div');
        citeDiv.classList.add('hanging-indent');
        citeDiv.classList.add('csl-entry');
        var biblioDiv = window.document.getElementById('ref-' + cite);
        if (biblioDiv) {
          citeDiv.innerHTML = biblioDiv.innerHTML;
        }
        popup.appendChild(citeDiv);
      });
      return popup.innerHTML;
    });
  }
});
