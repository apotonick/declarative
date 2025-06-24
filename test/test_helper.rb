require "minitest/autorun"
require "declarative"
require "declarative/testing"
require "ostruct"
require "trailblazer/core"

CU = Trailblazer::Core::Utils

Minitest::Spec.class_eval do
  def assert_equal(asserted, expected)
    super(expected, asserted)
  end
end
