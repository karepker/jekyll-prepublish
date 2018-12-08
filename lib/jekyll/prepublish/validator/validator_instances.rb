# Loads all validator instances.
require 'jekyll/prepublish/validator/html_span_validator'
require 'jekyll/prepublish/validator/internal_link_validator'
require 'jekyll/prepublish/validator/post_tag_validator'
require 'jekyll/prepublish/validator/validator_registry'

JekyllPrepublish::ValidatorRegistry.register(
  "post tag whitelist",
  lambda do |configuration|
    return JekyllPrepublish::PostTagValidator.new(configuration)
  end
)

JekyllPrepublish::ValidatorRegistry.register(
  "HTML span blacklist", lambda do |configuration|
    JekyllPrepublish::HtmlSpanValidator.new(configuration)
  end
)

JekyllPrepublish::ValidatorRegistry.register(
  "internal link",
  lambda do |_configuration|
    return JekyllPrepublish::InternalLinkValidator.new
  end
)
