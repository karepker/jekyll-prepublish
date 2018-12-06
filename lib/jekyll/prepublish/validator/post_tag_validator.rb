# Finds non-whitelisted tags.

module JekyllPrepublish
  class PostTagValidator
    def initialize(configuration)
      @whitelist = Set.new(
          configuration.fetch('tag_whitelist', Array.new))
    end

    def describe_validation
      "Checking tags are from whitelist [#{@whitelist.to_a.join(', ')}]."
    end

    def validate(post, _document, _site)
      tags = Set.new(post.data["tags"])
      # Check if tags are valid.
      if tags <= @whitelist
        return nil
      end

      # Create error message.
      tag_difference = tags - @whitelist
      "Tags not allowed are {#{tag_difference.to_a.join(", ")}}."
    end

  end
end
