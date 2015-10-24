module Declarative
  class Schema < Hash
    class Definition
      def initialize(name, options={}, &block)
        @options = {}
        @name    = name.to_s
        options  = options.clone

        # # defaults:
        # options[:parse_filter]  = Pipeline[*options[:parse_filter]]
        # options[:render_filter] = Pipeline[*options[:render_filter]]

        # setup!(options, &block)
        @options = options
      end

      def [](name)
        # @runtime_options[name]
        @options[name]
      end
    end

    def initialize(definition_class)
      @definition_class = definition_class
      super()
    end

    # #add is DSL for Schema#[]=.
    def add(name, options={}, &block)
      # if options[:inherit] and parent_property = get(name) # i like that: the :inherit shouldn't be handled outside.
      #   return parent_property.merge!(options, &block)
      # end
      # options.delete(:inherit) # TODO: can we handle the :inherit in one single place?

      if block
        base = nil
        options[:nested] = build_nested(base, options[:include_modules], name, options, &block)
      end




      self[name.to_s] = @definition_class.new(name, options, &block)
    end

    def get(name)
      self[name.to_s]
    end

  private
    def build_nested(base, includes, name, options, &block)
      nested = options.delete(:build_nested).()
      nested.module_eval &block
      nested

      # Module.new do
      #   # include Representable
      #   # feature *features # Representable::JSON or similar.
      #   include base if base # base when :inherit, or in decorator.

      #   module_eval &block
      # end
    end
  end
end