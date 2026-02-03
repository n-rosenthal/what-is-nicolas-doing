# [`#0003`] Renderizar Markdown
## Definições e Arquitetura do Serviço de Renderização
O que significa *renderizar* um documento Markdown em um *post*? Quando dizemos *renderizar* um documento Markdown, queremos dizer que iremos transformar a *string* conteúdo do post, formatada explicitamente em Markdown, para um *string* formatada explicitamente em HTML.

Esta *transformação* é implementada em nosso blog como um *serviço* composto por três partes:
1. o *renderizador* Markdown em si;
2. a renderização de *extensões* do Markdown;
3. a limpeza do HTML resultante.

Além de renderizar Markdown *puro*, estamos interessados em uma série de extensões à linguagem. Estas extensões são: 
- [Markdown Extra](https://python-markdown.github.io/extensions/);
- [Markdown Meta](https://python-markdown.github.io/extensions/meta/);
- [Markdown Toc](https://python-markdown.github.io/extensions/toc/).


### Arquitetura do Serviço de Renderização
```txt
backend/
  apps/
    blog/
      markdown/
        __init__.py
        renderer.py
        extensions.py
        sanitizer.py
      models.py
      services.py
```

Enquanto principal biblioteca para renderização de Markdown, usamos `python-markdown`, por questões de estabilidade e documentação/exposição na Internet amplas. **No futuro, desejaremos implementar *renderizadores customizados* e a possibilidade de renderizar *isto* mas não *aquilo* em um post específico**; estas *features* serão implementadas conforme for possível.

---
### Extensões do Markdown
```python
MARKDOWN_EXTENSIONS = [
    "codehilite",
    "tables",
    "toc",
    "admonition",
    "attr_list",
    "def_list",
]

MARKDOWN_EXTENSION_CONFIGS = {
    "codehilite": {
        "guess_lang": False,
        "css_class": "codehilite",
    },
    "toc": {
        "permalink": True,
    },
}
```

#### Renderização de LaTeX
Para renderizar blocos `$...$`, `$$...$$` e outros em TeX, usamos [MathJax](https://www.mathjax.org/) enquanto script em um arquivo estático, em `static/js/mathjax.js`:

```javascript
window.MathJax = {
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']],
    displayMath: [['$$', '$$'], ['\\[', '\\]']]
  },
  svg: { fontCache: 'global' }
};

(function () {
  var script = document.createElement('script');
  script.src = 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js';
  script.async = true;
  document.head.appendChild(script);
})();
```

#### Renderizar *code blocks* com *syntax highlighting*
Para renderizar codeblocks, usamos novamente a biblioteca `python-markdown`, mas agora em conjunto com `Pygments`. Primeiro, é necessário atualizar o *renderer*:

```python
import markdown

html = markdown.markdown(
    content,
    extensions=[
        "fenced_code",  # 'fenced code' é o que entendemos por 'code blocks' aqui
        "tables",
        "toc"
    ]
)
```
