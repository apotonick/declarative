module Declarative
  module Property
    # options.dup
    def property(name, options={}, &block)
      heritage.record(:property, name, options, &block)

      # actual implementation: # TODO: should we separate that? e.g. pass in method(:property)
      Implementation.new.(self, name, options, &block)
    end

    class Implementation
      def call(context, name, options={}, &block)
        context.instance_eval do
          def representable_attrs
            @representable_attrs ||= {definitions: {}}
          end
        end

        require "representable"
        require "representable/definition"

        # TODO: handle block extend: here.
        # context.representable_attrs[:definitions][name] = context.build_definition(name, options, &block)#Representable::Definition.new(name, options)

      end
    end
  end
end