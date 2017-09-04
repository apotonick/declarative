require "test_helper"

class DSLOptionsTest < Minitest::Spec
  it do
    defaults = Declarative::Hash.new( id: 1, connections: { first: 1, second: 2 } )

    options = defaults.merge(
      connections: Declarative::Hash::Merge( second: 3, third: 4 )
    ) # write this over original.

    options.must_equal( { id: 1, connections: { first: 1, second: 3, third: 4 } } )

    Declarative::Inspect(defaults).must_equal %{#<Declarative::Hash: @original={:id=>1, :connections=>{:first=>1, :second=>2}}>}
  end
end
