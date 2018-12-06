require 'jekyll/prepublish/validator/post_tag_validator'

describe JekyllPrepublish::PostTagValidator do
  it "describes validation" do
    configuration = Hash.new
    validator = JekyllPrepublish::PostTagValidator.new(configuration)
    expect(validator).to respond_to(:describe_validation)
  end

  it "marks all tags as bad when no whitelist is given" do
    post = instance_double("Jekyll::Page",
                           :data => {"tags" => Set.new(["movie"])})

    configuration = Hash.new
    validator = JekyllPrepublish::PostTagValidator.new(configuration)
    # Pass document, site as nil because they are unused.
    expect(validator.validate(post, nil, nil)).to include("movie")
  end

  it "returns nil when tags are a proper subset of whitelist" do
    post = instance_double("Jekyll::Page",
                           :data => {"tags" => Set.new(["movie"])})

    configuration = { "tag_whitelist" => %w{movie} }
    validator = JekyllPrepublish::PostTagValidator.new(configuration)
    # Pass document, site as nil because they are unused.
    expect(validator.validate(post, nil, nil)).to be_nil
  end

  it "returns nil when tags are equal to whitelist" do
    post = instance_double("Jekyll::Page",
                           :data => {"tags" => Set.new(["movie", "book",
                                                        "music"])})
    configuration = { "tag_whitelist" => %w{book movie music} }
    validator = JekyllPrepublish::PostTagValidator.new(configuration)
    # Pass document, site as nil because they are unused.
    expect(validator.validate(post, nil, nil)).to be_nil
  end

  it "finds tags that are not elements of whitelist" do
    post = instance_double("Jekyll::Page",
                           :data => {"tags" => Set.new(["very", "wrong"])})

    configuration = { "tag_whitelist" => %w{book movie music} }
    validator = JekyllPrepublish::PostTagValidator.new(configuration)
    # Pass document, site as nil because they are unused.
    expect(validator.validate(post, nil, nil)).to include("wrong")
    expect(validator.validate(post, nil, nil)).to include("very")
  end

end
