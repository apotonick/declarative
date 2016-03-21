module Declarative
  class Heritage < Array
    # Record inheritable assignments for replay in an inheriting class.
    def record(method, *args, &block)
      self << {method: method, args: DeepDup.(args), block: block} # DISCUSS: options.dup.
    end

    # Replay the recorded assignments on inheritor.
    def call(inheritor)
      each { |cfg| call!(inheritor, cfg) }
    end

    private def call!(inheritor, cfg)
      inheritor.send(cfg[:method], *cfg[:args], &cfg[:block])
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
