module Declarative
  module Schema
    module DSL
      def property(name, options={}, &block)
        options = {
          _composer:    default_nested_class,
        }.merge(options)

        options[:build_nested] = NestedBuilder if block
        options[:_defaults]    = defaults
        # TODO: test merge order. test :_composer.

        definitions.add(name, options, &block)
      end

      def defaults(options={}, &block)
        (@defaults ||= Declarative::Defaults.new).merge!(options, &block)
      end

      def definitions
        @definitions ||= Definitions.new(Definitions::Definition)
      end
    end

    NestedBuilder = ->(options) {
      base = Class.new(options[:base])
    }

      # Module.new do
      #   # include Representable
      #   # feature *features # Representable::JSON or similar.
      #   include base if base # base when :inherit, or in decorator.

      #   module_eval &block
      # end
  end
end
