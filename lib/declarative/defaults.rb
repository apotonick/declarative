module Declarative
  class Defaults
    def initialize
      @static_options  = {}
      @dynamic_options = ->(*) { {} }
    end

    # Set default values. Usually called in Schema::defaults.
    # This can be called multiple times and will "deep-merge" arrays, e.g. `_features: []`.
    def merge!(hash={}, &block)
      @static_options  = Variables.merge( @static_options, handle_array_and_deprecate(hash) )
      @dynamic_options = block if block_given?

      self
    end

    # Evaluate defaults and merge given_options into them.
    def call(name, given_options)
      # TODO: allow to receive rest of options/block in dynamic block. or, rather, test it as it was already implemented.
      evaluated_options = @dynamic_options.(name, given_options)

      options = Declarative::Variables.merge( @static_options, handle_array_and_deprecate(evaluated_options) )
      options = Declarative::Variables.merge( options, handle_array_and_deprecate(given_options) ) # FIXME: given_options is not tested!
    end

    def handle_array_and_deprecate(variables)
      wrapped = Hash[ variables.find_all { |k,v| v.is_a?(Array) }.collect { |k,v| [k, Variables::Append(v)] } ]

      warn "[Declarative] Defaults#merge! and #call still accept arrays and automatically prepend those. This is now deprecated, you should replace `ary` with `Declarative::Variables::Append(ary)`."

      variables.merge(wrapped)
    end
  end
end
