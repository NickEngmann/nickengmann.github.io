# Hypothetical module under test — simulates a Jekyll site validator in Python
import re
import yaml

REQUIRED_CONFIG_KEYS = ["title", "description", "url", "markdown", "timezone"]
SUPPORTED_MARKDOWN_ENGINES = ["kramdown", "redcarpet"]

def validate_config(config: dict) -> bool:
    for key in REQUIRED_CONFIG_KEYS:
        if key not in config:
            raise ValueError(f"Missing required config key: '{key}'")
    if config.get("markdown") not in SUPPORTED_MARKDOWN_ENGINES:
        raise ValueError("Unsupported markdown engine")
    return True

def validate_post_filename(filename: str) -> bool:
    # Jekyll post filenames: YYYY-MM-DD-title.md or .markdown
    pattern = r"^\d{4}-\d{2}-\d{2}-.+\.(md|markdown)$"
    return bool(re.match(pattern, filename))

def parse_frontmatter(filepath: str):
    with open(filepath, "r") as f:
        content = f.read()
    if not content.startswith("---\n"):
        raise ValueError("Missing frontmatter delimiter")
    parts = content.split("---\n", 2)
    if len(parts) < 3:
        raise ValueError("Malformed frontmatter")
    frontmatter = yaml.safe_load(parts[1])
    body = parts[2].strip()
    return frontmatter, body

def validate_post_frontmatter(frontmatter: dict) -> bool:
    required_keys = ["layout", "title", "date"]
    for key in required_keys:
        if key not in frontmatter:
            raise ValueError(f"Missing required frontmatter key: '{key}'")
    return True