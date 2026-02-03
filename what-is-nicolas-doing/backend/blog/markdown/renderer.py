"""
    `what-is-nicolas-doing/backend/blog/markdown/renderer.py`
    
    Renderizador de Markdown para HTML baseado sobre `python-markdown`.
"""

import markdown
from .extensions import MARKDOWN_EXTENSIONS, MARKDOWN_EXTENSION_CONFIGS
from .sanitizer import sanitize_html

md = markdown.Markdown(
    extensions=MARKDOWN_EXTENSIONS,
    extension_configs=MARKDOWN_EXTENSION_CONFIGS,
    output_format="html5",
)

def render_markdown(text: str) -> str:
    """
    Deterministically render Markdown → safe HTML.
    """
    md.reset()
    html = md.convert(text)
    return sanitize_html(html)
