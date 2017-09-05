require "test_helper"

class DSLOptionsTest < Minitest::Spec
  let(:defaults) { Declarative::Variables.new( id: 1, connections: { first: 1, second: 2 }, list: [3] ) }

  after do
    Declarative::Inspect(defaults).must_equal %{#<Declarative::Variables: @original={:id=>1, :connections=>{:first=>1, :second=>2}, :list=>[3]}>}
  end

  #- Merge
  it "merges Merge over original" do
    options = defaults.merge(
      connections: Declarative::Variables::Merge( second: 3, third: 4 )
    )

    options.must_equal( { id: 1, connections: { first: 1, second: 3, third: 4 }, :list=>[3] } )
  end

  it "accepts Procs" do
    options = defaults.merge(
      connections: proc = ->(*) { raise }
    )

    options.must_equal( { id: 1, connections: proc, :list=>[3] } )
  end

  it "overrides original without Merge" do
    options = defaults.merge( connections: { second: 3, third: 4 } )

    options.must_equal( { id: 1, connections: { second: 3, third: 4 }, :list=>[3] } )
  end

  it "creates new hash if original not existent" do
    options = defaults.merge(
      bla: Declarative::Variables::Merge( second: 3, third: 4 )
    )

    options.must_equal( {:id=>1, :connections=>{:first=>1, :second=>2}, :list=>[3], :bla=>{:second=>3, :third=>4}} )
  end

  #- Append
  it "appends to Array" do
    options = defaults.merge(
      list: Declarative::Variables::Append( [3, 4, 5] )
    )

    options.must_equal( { id: 1, connections: { first: 1, second: 2 }, :list=>[3, 3, 4, 5] } )
  end

  it "creates new array if original not existent" do
    options = defaults.merge(
      another_list: Declarative::Variables::Append( [3, 4, 5] )
    )

    options.must_equal( { id: 1, connections: { first: 1, second: 2 }, :list=>[3], :another_list=>[3, 4, 5] } )
  end
end
