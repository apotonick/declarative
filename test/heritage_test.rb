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
    heritage.record(:property, :id, {}, &Proc.new{}.extend(Declarative::Inspect))
  end

  it { RepresenterA.heritage.inspect.must_equal "[{:method=>:representation_wrap=, :args=>[true], :block=>nil}, {:method=>:property, :args=>[:name, {:enable=>true}], :block=>nil}, {:method=>:property, :args=>[:id, {}], :block=>#<Proc:@heritage_test.rb:13>}]" }
end