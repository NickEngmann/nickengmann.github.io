import pytest
from unittest.mock import MagicMock, patch, mock_open
import yaml

# Mock the external Ruby/Jekyll dependencies (e.g., via subprocess or file parsing)
@pytest.fixture
def mock_jekyll_config():
    return {
        "title": "My Personal Site",
        "description": "A personal GitHub Pages site",
        "url": "https://example.com",
        "baseurl": "/blog",
        "timezone": "UTC",
        "markdown": "kramdown",
        "plugins": ["jekyll-feed", "jekyll-seo-tag"],
    }

@pytest.fixture
def mock_post_frontmatter():
    return {
        "layout": "post",
        "title": "Hello World",
        "date": "2024-01-01 12:00:00 +0000",
        "categories": ["announcements"],
        "tags": ["intro"],
    }

def test_validates_required_config_keys(mock_jekyll_config):
    from tests.jekyll_validator import validate_config
    # Simulate config with missing required key
    incomplete_config = {k: v for k, v in mock_jekyll_config.items() if k != "title"}
    with pytest.raises(ValueError, match="Missing required config key: 'title'"):
        validate_config(incomplete_config)

def test_rejects_invalid_markdown_engine():
    from tests.jekyll_validator import validate_config
    bad_config = {"markdown": "invalid-engine"}
    with pytest.raises(ValueError, match="Unsupported markdown engine"):
        validate_config(bad_config)

def test_validates_post_filename_format():
    from tests.jekyll_validator import validate_post_filename
    assert validate_post_filename("2024-01-01-hello-world.md") is True
    assert validate_post_filename("2024-01-01-hello-world.markdown") is True
    assert validate_post_filename("hello-world.md") is False
    assert validate_post_filename("2024-1-1-hello.md") is False  # zero-padded month/day required

def test_parses_frontmatter_correctly(mock_post_frontmatter):
    from tests.jekyll_validator import parse_frontmatter
    # Simulate a post file with frontmatter
    content = "---\n" + yaml.dump(mock_post_frontmatter) + "---\n\nContent here."
    with patch("builtins.open", mock_open(read_data=content)):
        fm, body = parse_frontmatter("fake-post.md")
        assert fm == mock_post_frontmatter
        assert body.strip() == "Content here."

def test_detects_missing_required_frontmatter_keys(mock_post_frontmatter):
    from tests.jekyll_validator import validate_post_frontmatter
    incomplete = {k: v for k, v in mock_post_frontmatter.items() if k != "title"}
    with pytest.raises(ValueError, match="Missing required frontmatter key: 'title'"):
        validate_post_frontmatter(incomplete)