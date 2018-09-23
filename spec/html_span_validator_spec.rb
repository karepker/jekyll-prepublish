require 'nokogiri'
require 'jekyll/prepublish/validator/html_span_validator'

describe JekyllPrepublish::HtmlSpanValidator do
  it "describes validation" do
    validator = JekyllPrepublish::HtmlSpanValidator.new
    expect(validator).to respond_to(:describe_validation)
  end

  it "returns nil when spans are valid" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <span class="fine">Benevolent text</span>
  </body>
</html>})

    # Pass post, site as nil because they are unused.
    validator = JekyllPrepublish::HtmlSpanValidator.new
    expect(validator.validate(nil, document, nil)).to be_nil
  end

  it "finds one instance of a bad span" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <span class="remove">Text that should be removed</span>
  </body>
</html>})

    # Pass post, site as nil because they are unused.
    validator = JekyllPrepublish::HtmlSpanValidator.new
    expect(validator.validate(nil, document, nil)).to eql(
        ".remove has violations [Text that should be removed].")
  end

  it "returns all instances of bad span that should be removed" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <span class="remove">Text that should be removed</span>
    <span class="remove">More text that should be removed</span>
  </body>
</html>})

    # Pass post, site as nil because they are unused.
    validator = JekyllPrepublish::HtmlSpanValidator.new
    expect(validator.validate(nil, document, nil)).to eql(
      ".remove has violations [Text that should be removed, "\
      "More text that should be removed].")
  end

  it "returns multiple spans that should be removed" do
    document = Nokogiri::HTML(
    %q{<html>
  <body>
    <span class="remove">Text that should be removed</span>
    <span class="redact">Text that should be redacted</span>
  </body>
</html>})

    # Pass post, site as nil because they are unused.
    validator = JekyllPrepublish::HtmlSpanValidator.new
    expect(validator.validate(nil, document, nil)).to eql(
      %q{.remove has violations [Text that should be removed].
.redact has violations [Text that should be redacted].})
  end

end
