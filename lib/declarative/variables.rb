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
      original = @original.merge({}) # todo: use our DeepDup. # TODO: or how could we provide immutability?

      hash.each do |k, v| # fixme: REDUNDANT WITH Defaults.Merge
        if v.is_a?(Proc)
          original[k] = v.( original[k] )
        else
          original[k] = v
        end
      end

      original
    end

    def self.Merge(merged_hash)
      ->(original) do
        original.merge( merged_hash )
      end
    end # Merge()

    def self.Append(appended_array)
      ->(original) { (original || []) + appended_array }
    end
  end
end
