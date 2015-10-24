require "declarative"
require "minitest/autorun"
require "pp"

module Inspect
  def inspect
    super.sub(/0x\w+/, "")
  end
end
