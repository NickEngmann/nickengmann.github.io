# tests/html_validation_spec.rb
require_relative 'spec_helper'

describe 'HTML output validation' do
  let(:output_dir) { Pathname.new(Dir.mktmpdir) }

  it 'produces valid HTML (no broken tags)' do
    site, tmpdir = setup_jekyll_site('destination' => output_dir.to_s)

    site.process

    # Check for unclosed tags by parsing with Nokogiri (if available)
    # For minimal test, just ensure basic structure
    index_html = output_dir.join('index.html').read
    expect(index_html).to match(%r{<html[^>]*>.*</html>}m)
    expect(index_html).to match(%r{<body>.*</body>}m)
  end

  it 'passes HTMLProofer checks (basic)' do
    site, tmpdir = setup_jekyll_site('destination' => output_dir.to_s)

    site.process

    # Run HTMLProofer on output
    HTMLProofer.check_directories(
      [output_dir.to_s],
      {
        :allow_hash_href => true,
        :empty_alt_ignore => true,
        :file_ignore => [/feed\.xml/],
        :parallel => { :in_processes => 1 },
        :verbose => false,
        :typhoeus => { :timeout => 1 }
      }
    ).run
  end
end