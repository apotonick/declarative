require "declarative/version"
require "declarative/definitions"
require "declarative/defaults"
require "declarative/schema"
require "declarative/deep_dup"

module Declarative
  class Heritage < Array
    def record(method, *args, &block)
      self << {method: method, args: DeepDup.(args), block: block} # DISCUSS: options.dup.
    end

    def call(inheritor)
      each do |cfg|
        inheritor.send(cfg[:method], *cfg[:args], &cfg[:block])
      end
    end


    module DSL
      def heritage
        @heritage ||= Heritage.new
      end
    end

    module Inherited
      def inherited(subclass)
        super
        heritage.(subclass)
      end
    end

    module Included
      def included(mod)
        super
        heritage.(mod)
      end
    end
  end
end
