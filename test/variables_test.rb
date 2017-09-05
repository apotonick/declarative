require "test_helper"

class DSLOptionsTest < Minitest::Spec
  let(:defaults) { Declarative::Variables.new( id: 1, connections: { first: 1, second: 2 } ) }

  after do
    Declarative::Inspect(defaults).must_equal %{#<Declarative::Variables: @original={:id=>1, :connections=>{:first=>1, :second=>2}}>}
  end

  it "merges Merge over original" do
    options = defaults.merge(
      connections: Declarative::Variables::Merge( second: 3, third: 4 )
    )

    options.must_equal( { id: 1, connections: { first: 1, second: 3, third: 4 } } )
  end

  it "overrides original without Merge" do
    options = defaults.merge( connections: { second: 3, third: 4 } )

    options.must_equal( { id: 1, connections: { second: 3, third: 4 } } )
  end

  it "breaks when Merge can't find source to merge into" do
    puts "fix me"
    options = defaults.merge(
      ___connections: Declarative::Variables::Merge( second: 3, third: 4 )
    )

    options.keys.must_equal([:id, :connections, :___connections])
  end
end
