require 'jekyll'
require 'set'

module JekyllPrepublish
  class ValidatorRegistry
    include Enumerable
    @@validators = Set.new

    def each(&block)
      @@validators.each(&block)
    end

    class << self
      # Registers a class to the set of validators. Returns the class or yields
      # it to a block if the block was given.
      #
      # Some inspiration taken from this website, but see note below:
      # http://benjamintan.io/blog/2015/03/28/ruby-block-patterns-and-how-to-implement-file-open/
      def register(klass, &block)
        @@validators.add(klass)
        return klass unless block_given?
        # If this `begin` block isn't here, `ensure` gets run immediately after
        # returning.
        begin
          yield(klass)
        ensure
          unregister(klass)
        end
      end

      # Removes a class from the set of validators. Returns self if the object
      # was successfully deleted, and nil if it was not in the set.
      def unregister(klass)
        @@validators.delete?(klass)
      end

    end
  end
end
