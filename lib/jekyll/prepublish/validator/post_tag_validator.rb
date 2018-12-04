# Finds disallowed tags.

module JekyllPrepublish
  class PostTagValidator
    def initialize(configuration)
      @whitelist = Set.new(TAG_WHITELIST)
    end

    def describe_validation
      'Checking tags.'
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

    private

    TAG_WHITELIST = %w{movie book music TV}
  end
end
