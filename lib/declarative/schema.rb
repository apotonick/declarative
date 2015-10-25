module Declarative
  module Schema
    module DSL
      def property(name, options={}, &block)
        options = {
          build_nested: NestedBuilder,
          _composer:    default_nested_class,
        }.merge(options)
        # TODO: test merge order. test :_composer.

        puts "@@@@@ #{options.inspect}"

        definitions.add(name, options, &block)
      end

    private
      def definitions
        @definitions ||= Definitions.new(Definitions::Definition)
      end
    end

    NestedBuilder = ->(options) {
      base = options[:base]
    }

      # Module.new do
      #   # include Representable
      #   # feature *features # Representable::JSON or similar.
      #   include base if base # base when :inherit, or in decorator.

      #   module_eval &block
      # end
  end
end
