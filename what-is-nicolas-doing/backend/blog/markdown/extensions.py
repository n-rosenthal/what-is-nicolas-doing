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
        "use_pygments": True,
        "noclasses": False,  # 🔑 gera classes CSS
    },
    "toc": {
        "permalink": True,
    },
}