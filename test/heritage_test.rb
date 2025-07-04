require "test_helper"

class HeritageTest < Minitest::Spec
  P = Proc.new{}.extend(Declarative::Inspect)
  # #record
  module RepresenterA
    extend Declarative::Heritage::DSL

    # one arg.
    heritage.record(:representation_wrap=, true)
    # 2 args.
    heritage.record(:property, :name, enable: true)
    # 3 args.
    heritage.record(:property, :id, {}, &P)
  end

  it do
    if RUBY_VERSION >= '2.7.0'
      exp = "[{:method=>:representation_wrap=, :args=>[true], :block=>nil}, {:method=>:property, :args=>[:name, {:enable=>true}], :block=>nil}, {:method=>:property, :args=>[:id, {}], :block=>#<Proc: heritage_test.rb:4>}]"
    else
      exp = "[{:method=>:representation_wrap=, :args=>[true], :block=>nil}, {:method=>:property, :args=>[:name, {:enable=>true}], :block=>nil}, {:method=>:property, :args=>[:id, {}], :block=>#<Proc:@heritage_test.rb:4>}]"
    end
    assert_equal exp, CU.inspect(RepresenterA.heritage.inspect)
  end


  describe "dup of arguments" do
    module B
      extend Declarative::Heritage::DSL

      options = {render: true, nested: {render: false}}

      heritage.record(:property, :name, options, &P)

      options[:parse] = true
      options[:nested][:parse] = false
    end

    it {
      if RUBY_VERSION >= '2.7.0'
        exp = "[{:method=>:property, :args=>[:name, {:render=>true, :nested=>{:render=>false}}], :block=>#<Proc: heritage_test.rb:4>}]"
      else
        exp = "[{:method=>:property, :args=>[:name, {:render=>true, :nested=>{:render=>false}}], :block=>#<Proc:@heritage_test.rb:4>}]"
      end
      assert_equal exp, CU.inspect(B.heritage.inspect)
    }
  end

  describe "#call with block" do
    let (:heritage) { Declarative::Heritage.new.record(:property, :id, {}) }

    class CallWithBlock
      def self.property(name, options)
        @args = [name, options]
      end
    end

    it do
      heritage.(CallWithBlock) { |cfg| cfg[:args].last.merge!(_inherited: true) }
      assert_equal [:id, {:_inherited=>true}], CallWithBlock.instance_variable_get(:@args)
    end
  end
end
