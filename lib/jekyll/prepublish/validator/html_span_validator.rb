# Finds blacklisted <span> elements in rendered HTML.

module JekyllPrepublish
  class HtmlSpanValidator
    def initialize(configuration)
      @blacklisted_classes = Set.new(
          configuration.fetch('blacklisted_classes', Array.new))
    end

    def describe_validation
      'Checking for blacklisted <span> classes: '\
      "[#{@blacklisted_classes.to_a.join(', ')}]."
    end

    # Finds blacklisted <span> elements by class and returns an error indicating
    # where violations were found, or nil if no violations were found.
    def validate(_post, document, _site)
      # Credit: https://stackoverflow.com/questions/2698460/.
      blacklisted_classes_and_text = Hash.new { |h, k| h[k] = [] }
      @blacklisted_classes.each do |class_text|
        document.search(".#{class_text}").each do |node|
          blacklisted_classes_and_text[class_text].push(node.text)
        end
      end

      return nil if blacklisted_classes_and_text.empty?

      # Create error message.
      blacklisted_classes_and_text.map { |class_text, violations|
        ".#{class_text} has violations [#{violations.join(', ')}]."
      }.join("\n")
    end

  end
end
