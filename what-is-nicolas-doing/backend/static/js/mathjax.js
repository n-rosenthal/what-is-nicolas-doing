// mathjax.js

(function () {
    function hasMath() {
      return (
        document.querySelector("script[type='math/tex']") ||
        document.body.textContent.match(/\$(.+?)\$/) ||
        document.body.textContent.match(/\\\((.+?)\\\)/)
      );
    }
  
    if (!hasMath()) return;
  
    window.MathJax = {
      tex: {
        inlineMath: [["$", "$"], ["\\(", "\\)"]],
        displayMath: [["$$", "$$"], ["\\[", "\\]"]],
      },
      svg: {
        fontCache: "global"
      }
    };
  
    const script = document.createElement("script");
    script.src = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js";
    script.async = true;
    document.head.appendChild(script);
  })();
  