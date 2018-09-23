# Loads all validator instances.
require 'jekyll/prepublish/validator/html_span_validator'
require 'jekyll/prepublish/validator/internal_link_validator'
require 'jekyll/prepublish/validator/post_tag_validator'
require 'jekyll/prepublish/validator/validator_registry'

JekyllPrepublish::ValidatorRegistry.register(
  JekyllPrepublish::PostTagValidator.new)

JekyllPrepublish::ValidatorRegistry.register(
  JekyllPrepublish::HtmlSpanValidator.new)

JekyllPrepublish::ValidatorRegistry.register(
  JekyllPrepublish::InternalLinkValidator.new)
