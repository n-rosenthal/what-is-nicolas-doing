MARKDOWN_EXTENSIONS = [
    "fenced_code",
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