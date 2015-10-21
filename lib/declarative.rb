require "declarative/version"

module Declarative
  def self.included(includer)
    includer.extend DSL, Inheritance
  end

  module DSL
    def declarative_attrs
      @declarative_attrs ||= build_config
    end

    def build_config
      # Config.new
      {}
    end
  end

  module Inheritance
    def included(includer)
      declarative_attrs.each do |method, args|
        args.each { |name, options, block| includer.send(method, name, options, &block) }
      end
    end
  end
end
