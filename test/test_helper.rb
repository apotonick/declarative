require "declarative"
require "minitest/autorun"
require "pp"

module Inspect
  def inspect
    string = super
    if is_a?(Proc)
      elements = string.split("/")
      string = "#{elements.first}#{elements.last}"
    end
    string.sub(/0x\w+/, "")
  end

  module Schema
    def inspect
      definitions.extend(Definitions::Inspect)
      "Schema: #{definitions.inspect}"
    end
  end
end


module Definitions
  module Inspect
    def inspect
      each { |n, dfn|
        dfn.extend(::Inspect)
        if dfn[:nested] && dfn[:nested].is_a?(Declarative::Schema::DSL)
          dfn[:nested].extend(::Inspect::Schema)
        else
          dfn[:nested].extend(::Definitions::Inspect) if dfn[:nested]
        end
      }
      super
    end

    def get(*)
      super.extend(::Inspect)
    end
  end
end