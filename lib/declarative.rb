require "declarative/version"
require "declarative/definitions"
require "declarative/defaults"
require "declarative/schema"

module Declarative
  class Heritage < Array
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


    def record(method, *args, &block)
      self << {method: method, args: DeepDup.(args), block: block} # DISCUSS: options.dup.
    end

    def call(inheritor)
      each do |cfg|
        inheritor.send(cfg[:method], *cfg[:args], &cfg[:block])
      end
    end
  end

  class DeepDup
    def self.call(args)
      return Array[*dup_items(args)] if args.is_a?(Array)
      return Hash[dup_items(args)] if args.is_a?(Hash)
      args
    end

  private
    def self.dup_items(arr)
      arr.to_a.collect { |v| call(v) }
    end
  end
end
