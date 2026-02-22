import pytest

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