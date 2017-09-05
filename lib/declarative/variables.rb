module Declarative
  # Implements the pattern of maintaining a hash of key/values (usually "defaults")
  # that are mutated several times by user and library code (override defaults).
  #
  # The Variables instance then represents the configuration data to be processed by the
  # using library (e.g. Representable or Trailblazer).
  class Variables
    def initialize(original)
      @original = original
    end

    def merge(hash)
      original = @original.merge({}) # todo: use our DeepDup.

      hash.each do |k, v| # fixme: REDUNDANT WITH Defaults.Merge
        original[k] = v and next unless original.has_key?(k)
        original[k] = v.( original[k] ) and next if v.is_a?(Proc)


        original[k] = v and next unless original[k].is_a?(Array)
        original[k] = original[k] += v # only for arrays.
      end

      original
    end

    def self.Merge(new_hash)
      ->(original) do
        original.merge( new_hash )
      end
    end # Merge()

  end
end
