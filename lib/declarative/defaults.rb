module Declarative
  class Defaults
    def initialize
      @static_options  = {}
      @dynamic_options = ->(*) { Hash.new }
    end

    # Set default values. Usually called in Schema::defaults.
    # This can be called multiple times and will "deep-merge" arrays, e.g. `_features: []`.
    def merge!(hash={}, &block)
      @static_options = Merge.(@static_options, hash)

      @dynamic_options = block if block_given?
      self
    end

    # Evaluate defaults and merge given_options into them.
    def call(name, given_options)
      # TODO: allow to receive rest of options/block in dynamic block. or, rather, test it as it was already implemented.
      evaluated_options = @dynamic_options.(name, given_options)

      options = Merge.(@static_options, evaluated_options)
      options = options.merge(given_options)
    end

    # Private! Don't use this anywhere.
    # Merges two hashes and joins same-named arrays. This is often needed
    # when dealing with defaults.
    class Merge
      def self.call(a, b)
        a = a.dup
        b.each do |k, v|
          a[k] = v and next unless a.has_key?(k)
          a[k] = v and next unless a[k].is_a?(Array)
          a[k] = a[k] += v # only for arrays.
        end

        a
      end
    end
  end
end
