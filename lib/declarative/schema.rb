require "declarative/defaults"
require "declarative"

module Declarative
  # Include this to maintain inheritable, nested schemas with ::defaults and
  # ::feature the way we have it in Representable, Reform, and Disposable.
  #
  # The schema with its defnitions will be kept in ::definitions.
  module Schema
    module DSL
      def property(name, options={}, &block)
        heritage.record(:property, name, options, &block)

        options = {
          _base:    default_nested_class,
        }.merge(options)

        options[:_nested_builder] = nested_builder if block
        options[:_defaults]       = _defaults

        definitions.add(name, options, &block)
      end

      def defaults(options={}, &block)
        heritage.record(:defaults, options, &block)

        _defaults.merge!(options, &block)
      end

      def definitions
        @definitions ||= Definitions.new(definition_class)
      end

      def definition_class # TODO: test me.
        Definitions::Definition
      end

    private
      def _defaults
        @defaults ||= Declarative::Defaults.new
      end

      def nested_builder
        NestedBuilder
      end
    end

    module Heritage
      def heritage
        @heritage ||= ::Declarative::Heritage.new
      end

      def inherited(subclass) # DISCUSS: this could be in Decorator? but then we couldn't do B < A(include X) for non-decorators, right?
        super
        heritage.(subclass)
      end
    end

    module Feature
      # features are registered as defaults using _features, which in turn get translated to
      # Class.new... { feature mod } which makes it recursive in nested schemas.
      def feature(*mods)
        mods.each do |mod|
          include mod
          register_feature(mod)
        end
      end

    private
      def register_feature(mod)
        heritage.record(:register_feature, mod) # this is only for inheritance between decorators and modules!!! ("horizontal and vertical")

        defaults[:_features] ||= []
        defaults[:_features] << mod
      end
    end


    NestedBuilder = ->(options) {
      base = Class.new(options[:_base]) do
        feature *options[:_features]
        class_eval(&options[:_block])
      end
    }

      # Module.new do
      #   # include Representable
      #   # feature *features # Representable::JSON or similar.
      #   include base if base # base when :inherit, or in decorator.

      #   module_eval &block
      # end
  end
end
