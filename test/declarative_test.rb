require "test_helper"

class DeclarativeTest < Minitest::Spec
  module RepresenterA
    include Declarative

    def self.property(name, options={}, &block)
      heritage.record(:property, name, options, &block.extend(Inspect))
    end

    property :id
    property :artist do
    end
  end

  class DecoratorA
    def self.property(name, options={}, &block)
      heritage.record(:property, name, options, &block.extend(Inspect))
    end

    include Declarative
    include RepresenterA

    # add more. they shouldn't bleed into RepresenterA, of course.
    property :label
  end

  it { RepresenterA.heritage.inspect.must_equal  "[{:method=>:property, :args=>[:id, {}], :block=>nil}, {:method=>:property, :args=>[:artist, {}], :block=>#<Proc:@declarative_test.rb:12>}]" }
  it { DecoratorA.heritage.inspect.must_equal    "[{:method=>:property, :args=>[:id, {}], :block=>nil}, {:method=>:property, :args=>[:artist, {}], :block=>#<Proc:@declarative_test.rb:12>}, {:method=>:property, :args=>[:label, {}], :block=>nil}]" }

  # attrs[:property] when it wasn't initialized

end
