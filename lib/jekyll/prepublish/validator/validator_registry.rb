require 'jekyll'

module JekyllPrepublish
  class ValidatorRegistry
    include Enumerable
    @@validator_initializers = Hash.new

    # Loops through each key and initialized validator.
    def each_validator(jekyll_prepublish_configuration, &block)
      return to_enum(:each_validator,
                     jekyll_prepublish_configuration) unless block_given?
      @@validator_initializers.each_pair do |key, initializer|
        validator_configuration = jekyll_prepublish_configuration.fetch(
            key, Hash.new)
        yield(key, initializer.call(validator_configuration))
      end
    end

    # Loops through each key and validator initialization function.
    def each(&block)
      @@validator_initializers.each(&block)
    end

    class << self
      # Registers a class to the set of validators.
      def register(key, validator_initializer, &block)
        @@validator_initializers[key] = validator_initializer
      end

      # Removes a class from the set of validators. Returns self if the object
      # was successfully deleted, and nil if it was not in the set.
      def unregister(key)
        @@validator_initializers.delete(key)
      end

    end
  end
end
