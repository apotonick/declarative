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
end


module Definitions
  module Inspect
    def inspect
      each { |n, dfn|
        dfn.extend(::Inspect)
        dfn[:nested].extend(::Inspect) if dfn[:nested]
        dfn[:nested].extend(::Definitions::Inspect) if dfn[:nested]
      }
      super
    end

    def get(*)
      super.extend(::Inspect)
    end
  end
end