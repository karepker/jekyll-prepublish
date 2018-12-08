require 'jekyll'

module JekyllPrepublish
  class ValidatorRegistry
    include Enumerable
    @@validator_initializers = Hash.new

    # Attempts to run each validator given in "validators" in the configuration.
    # If the validator is not found, will emit a warning and continue.
    def each_validator(validators_configuration, &block)
      return to_enum(:each_validator,
                     validators_configuration) unless block_given?
      validators_configuration.each_pair do |key, configuration|
        begin
          initializer = @@validator_initializers.fetch(key)
        rescue KeyError => e
          Jekyll.logger.warn("#{e.message}")
          next
        end
        yield(key, initializer.call(configuration))
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
