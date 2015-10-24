require "declarative/version"

module Declarative
  def self.included(includer)
    includer.extend DSL, Inheritance
  end

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


  class Heritage < Hash
    def record(method, name, options=nil, &block)
      self[method] ||= []
      # FIXME: dup all additional args?
      self[method] << {args: [name, options ? options.dup : nil].compact, block: block} # DISCUSS: options.dup.
    end

    def call(inheritor)
      each do |method, calls|
        calls.each { |cfg| inheritor.send(method, *cfg[:args], &cfg[:block]) }
      end
    end
  end
end
