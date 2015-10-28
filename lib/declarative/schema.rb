module Declarative
  # Include this to maintain inheritable, nested schemas with ::defaults and
  # ::feature the way we have it in Representable, Reform, and Disposable.
  #
  # The schema with its defnitions will be kept in ::definitions.
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

    module Feature
      # features are registered as defaults using :include_modules, which in turn get translated to
      # Class.new... { feature mod } which makes it recursive in nested schemas.
      def feature(*mods)
        mods.each do |mod|
          include mod
          register_feature(mod)
        end
      end

    private
      def register_feature(mod)
        # heritage.record(:register_feature, mod) # this is only for inheritance between decorators and modules!!! ("horizontal and vertical")

        defaults[:include_modules] ||= []
        defaults[:include_modules] << mod
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
