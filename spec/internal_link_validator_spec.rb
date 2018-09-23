require 'jekyll/prepublish/validator/internal_link_validator'

describe JekyllPrepublish::InternalLinkValidator do
  # Note: All "pretty" URLs returned by mocked pages/posts have a trailing slash
  # because Jekyll adds that.

  it "describes validation" do
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator).to respond_to(:describe_validation)
  end

  it "returns nil when links are contained in posts" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="/some/uri/">This link is fine.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => nil})
    post = instance_double("Jekyll::Page", {:url => "/some/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to be_nil
  end

  it "returns nil when links are contained in pages" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="/some/uri/page.html">This link is fine.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => nil})
    post = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/some/uri/page.html"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to be_nil
  end

  it "returns nil for external links when site url is nil" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="http://external.com">This link is fine.</a>
    <a href="https://external.com">So is this one.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => nil})
    post = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri2/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to be_nil
  end

  it "returns nil for external links when they don't match the site url" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="http://external.com">This link is fine.</a>
    <a href="https://external.com">So is this one.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => "http://example.com"})
    post = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri2/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to be_nil
  end

  it "returns nonexistent links in error" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="/bad/link/">This link is bad.</a>
    <a href="/some/uri/">This link is fine.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => nil})
    post = instance_double("Jekyll::Page", {:url => "/some/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to eql(
        "/bad/link/ does not exist!")
  end

  it "returns nonexistent links without trailing slashes" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="/some/uri">This link is missing a trailing slash.</a>
    <a href="/some/uri/">This link is fine.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => nil})
    post = instance_double("Jekyll::Page", {:url => "/some/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to eql(
        "/some/uri does not exist!")
  end

  it "returns domain-prefixed nonexistent links without trailing slashes" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="http://example.com/some/uri">
      This link is missing a trailing slash.
    </a>
    <a href="/some/uri/">This link is fine.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => "http://example.com"})
    post = instance_double("Jekyll::Page", {:url => "/some/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to eql(
      "http://example.com/some/uri does not exist!")
  end

  it "returns nonexistent links with the wrong scheme" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="https://example.com/some/uri/">
      This link has the wrong scheme.
    </a>
    <a href="/some/uri/">This link is fine.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => "http://example.com"})
    post = instance_double("Jekyll::Page", {:url => "/some/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to eql(
      "https://example.com/some/uri/ has the wrong scheme!")
  end

  it "returns all reasons a link is bad" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="https://example.com/some/uri">
      This link has the wrong scheme and doesn't exist.
    </a>
    <a href="/some/uri/">This link is fine.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => "http://example.com"})
    post = instance_double("Jekyll::Page", {:url => "/some/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to eql(
      "https://example.com/some/uri has the wrong scheme and does not exist!")
  end

  it "returns all links that are bad" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <a href="/bad/link1/">This doesn't exist.</a>
    <a href="/some/uri/">This link is fine.</a>
    <a href="/bad/link2/">This doesn't exist.</a>
  </body>
</html>})

    site = instance_double("Jekyll::Site")
    allow(site).to receive(:config).and_return({"url" => "http://example.com"})
    post = instance_double("Jekyll::Page", {:url => "/some/uri/"})
    allow(site).to receive_message_chain(:posts, :docs).and_return [post]
    page = instance_double("Jekyll::Page", {:url => "/unused/uri/"})
    allow(site).to receive(:pages).and_return [page]

    # Pass post as nil because it is unused.
    validator = JekyllPrepublish::InternalLinkValidator.new
    expect(validator.validate(nil, document, site)).to eql(
      %q{/bad/link1/ does not exist!
/bad/link2/ does not exist!})
  end

end
