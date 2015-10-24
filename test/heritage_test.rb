require "test_helper"

class HeritageTest < Minitest::Spec
  # #record
  module RepresenterA
    extend Declarative::DSL

    # one arg.
    heritage.record(:representation_wrap=, true)
    # 2 args.
    heritage.record(:property, :name, enable: true)
    # 3 args.
    heritage.record(:property, :id, {}, &Proc.new{}.extend(Inspect))
  end

  it { RepresenterA.heritage.inspect.must_equal "{:representation_wrap==>[{:args=>[true], :block=>nil}], :property=>[{:args=>[:name, {:enable=>true}], :block=>nil}, {:args=>[:id, {}], :block=>#<Proc:@test/heritage_test.rb:12>}]}" }
end