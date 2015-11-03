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

    # To be extended into classes using Heritage. Inherits the heritage.
    module Inherited
      def inherited(subclass)
        super
        heritage.(subclass)
      end
    end

    # To be included into modules using Heritage. When included, inherits the heritage.
    module Included
      def included(mod)
        super
        heritage.(mod)
      end
    end
  end
end