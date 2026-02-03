import bleach

ALLOWED_TAGS = bleach.sanitizer.ALLOWED_TAGS | {
    "h1", "h2", "h3", "h4", "h5", "h6",
    "pre", "code", "span",
    "table", "thead", "tbody", "tr", "th", "td",
    "div",
}

ALLOWED_ATTRIBUTES = {
    "*": ["class", "id"],
    "a": ["href", "title"],
    "img": ["src", "alt", "title"],
}

def sanitize_html(html: str) -> str:
    """
    Sanitizes HTML by removing all tags and attributes except those
    explicitly allowed.

    Args:
        html: str, the HTML to sanitize.

    Returns:
        str, the sanitized HTML.
    """
    return bleach.clean(
        html,
        tags=ALLOWED_TAGS,
        attributes=ALLOWED_ATTRIBUTES,
        strip=True,
    )
