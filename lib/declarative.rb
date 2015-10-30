require "declarative/version"
require "declarative/definitions"
require "declarative/defaults"
require "declarative/schema"

module Declarative
  module DSL
    def heritage
      @heritage ||= Heritage.new
    end
  end

  module Inheritance
    def included(includer)
      heritage.(includer)
    end
  end


  class Heritage < Array
    def record(method, name, options=nil, &block)
      self << {method: method, args: [name, options ? options.dup : nil].compact, block: block} # DISCUSS: options.dup.
    end

    def call(inheritor)
      each do |cfg|
        inheritor.send(cfg[:method], *cfg[:args], &cfg[:block])
      end
    end
  end
end
