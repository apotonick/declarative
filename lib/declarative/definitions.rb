module Declarative
  class Definitions < Hash
    class Definition
      def initialize(name, options={}, &block)
        @options = options.clone
        @name    = name.to_s
      end

      attr_reader :options # TODO: are we gonna keep this?

      def [](name)
        @options[name]
      end
    end

    def initialize(definition_class)
      @definition_class = definition_class
      super()
    end

    # #add is high-level behavior for Definitions#[]=.
    # reserved options:
    #   :_features
    #   :_defaults
    #   :_base
    def add(name, options={}, &block)
      options = options[:_defaults].(name, options) if options[:_defaults] # FIXME: pipeline?
      base    = options[:_base]

      if options.delete(:inherit) and parent_property = get(name)
        base = parent_property[:nested]
        options = parent_property.options.merge(options) # TODO: Definition#merge
      end

      if block
        options[:nested] = build_nested(
          options.merge(
            _base: base,
            _name: name,
            _block: block,
          )
        )
      end

      # clean up, we don't want that stored in the Definition instance.
      [:_defaults, :_base, :_nested_builder, :_features].each { |key| options.delete(key) }

      self[name.to_s] = @definition_class.new(name, options)
    end

    def get(name)
      self[name.to_s]
    end

  private
    def build_nested(options)
      nested = options[:_nested_builder].(options)

      # Module.new do
      #   # include Representable
      #   # feature *features # Representable::JSON or similar.
      #   include base if base # base when :inherit, or in decorator.

      #   module_eval &block
      # end
    end
  end
end