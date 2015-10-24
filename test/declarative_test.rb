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

  it { RepresenterA.heritage.inspect.must_equal  "{:property=>[{:args=>[:id, {}], :block=>nil}, {:args=>[:artist, {}], :block=>#<Proc:@test/declarative_test.rb:12>}]}" }
  it { DecoratorA.heritage.inspect.must_equal    "{:property=>[{:args=>[:id, {}], :block=>nil}, {:args=>[:artist, {}], :block=>#<Proc:@test/declarative_test.rb:12>}, {:args=>[:label, {}], :block=>nil}]}" }

  # attrs[:property] when it wasn't initialized

end


require "declarative/property"
class PropertyTest < Minitest::Spec
  module RepresenterA
    include Declarative
    extend Declarative::Property

    global_options = {decorator: true}

    property :id,     global_options
    property :artist, global_options

    heritage[:property][1][:args][1][:decorator] = false # TODO: use the property Definition interface for this.
  end

  it { RepresenterA.heritage.inspect.must_equal "{:property=>[{:args=>[:id, {:decorator=>true}], :block=>nil}, {:args=>[:artist, {:decorator=>false}], :block=>nil}]}" }

  it do
    pp RepresenterA.representable_attrs
  end
end