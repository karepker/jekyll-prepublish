require 'jekyll'

module JekyllPrepublish
  class ValidatorRegistry
    include Enumerable
    @@validator_initializers = Hash.new

    def each(&block)
      return to_enum(:each) unless block_given?
      @@validator_initializers.each_pair do |key, initializer|
        yield(key, initializer.call)
      end
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
