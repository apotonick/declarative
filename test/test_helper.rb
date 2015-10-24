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
