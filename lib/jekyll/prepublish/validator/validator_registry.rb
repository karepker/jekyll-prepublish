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
      # Registers a class to the set of validators. Returns the class or yields
      # it to a block if the block was given.
      #
      # Some inspiration taken from this website, but see note below:
      # http://benjamintan.io/blog/2015/03/28/ruby-block-patterns-and-how-to-implement-file-open/
      def register(key, validator_initializer, &block)
        @@validator_initializers[key] = validator_initializer
        return key, validator_initializer unless block_given?
        # If this `begin` block isn't here, `ensure` gets run immediately after
        # returning.
        begin
          yield(validator_initializer.call)
        ensure
          unregister(key)
        end
      end

      # Removes a class from the set of validators. Returns self if the object
      # was successfully deleted, and nil if it was not in the set.
      def unregister(key)
        @@validator_initializers.delete(key)
      end

    end
  end
end
