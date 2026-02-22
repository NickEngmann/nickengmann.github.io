# tests/jekyll_build_spec.rb
require_relative 'spec_helper'

describe 'Jekyll site build' do
  let(:output_dir) { Pathname.new(Dir.mktmpdir) }

  it 'builds successfully with default config' do
    site, tmpdir = setup_jekyll_site('destination' => output_dir.to_s)

    expect { site.process }.to_not raise_error
    expect(output_dir.join('index.html')).to exist
    expect(output_dir.join('2024/01/01/hello-world.html')).to exist
  end

  it 'renders Liquid templates correctly' do
    site, tmpdir = setup_jekyll_site('destination' => output_dir.to_s)

    site.process

    index_html = output_dir.join('index.html').read
    expect(index_html).to include('Test Site')
    expect(index_html).to include('Hello World')
  end

  it 'includes header partial in layouts' do
    site, tmpdir = setup_jekyll_site('destination' => output_dir.to_s)

    site.process

    post_html = output_dir.join('2024/01/01/hello-world.html').read
    expect(post_html).to include('<header><h2>Test Site</h2></header>')
  end

  it 'generates expected output structure' do
    site, tmpdir = setup_jekyll_site('destination' => output_dir.to_s)

    site.process

    expect(output_dir.join('_site')).to_not exist # Jekyll 3.9 writes directly to destination
    expect(output_dir.join('feed.xml')).to exist
  end

  it 'handles excerpt separator correctly' do
    # Create a post with explicit excerpt
    site, tmpdir = setup_jekyll_site('destination' => output_dir.to_s)
    site.source = tmpdir

    # Override config to set excerpt_separator
    config = Jekyll.configuration(
      'source' => tmpdir,
      'destination' => output_dir.to_s,
      'excerpt_separator' => "\n\n"
    )
    site = Jekyll::Site.new(config)

    # Create post with two paragraphs
    post_file = Pathname.new(tmpdir).join('_posts/2024-01-02-excerpt-test.md')
    post_file.write <<~MD
      ---
      layout: post
      title: "Excerpt Test"
      ---
      First paragraph.

      Second paragraph.
    MD

    site.process

    post_html = output_dir.join('2024/01/02/excerpt-test.html').read
    expect(post_html).to include('First paragraph.')
    expect(post_html).to include('Second paragraph.')
  end
end