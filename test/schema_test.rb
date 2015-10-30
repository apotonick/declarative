require "test_helper"

class SchemaTest < Minitest::Spec
  class Decorator
    extend Declarative::Schema::DSL
    extend Declarative::Schema::Feature # TODO: make automatic
    extend Declarative::Schema::Heritage # TODO: make automatic

    def self.default_nested_class
      Decorator
    end
  end

  module AddLinks
    def self.included(includer)
      super
      includer.property(:links)
    end
  end

  class Concrete < Decorator
    defaults render_nil: true do |name|
      { as: name.to_s.upcase }
    end
    feature AddLinks

    property :artist, cool: true do
      property :name
      property :band, crazy: nil do
        property :location
      end
    end

    property :id, unique: true, value: 1
  end


  it do
    Concrete.extend(Declarative::Inspect::Schema)
    Concrete.inspect
    pp Concrete.definitions.get(:artist).options
    # pp Concrete.definitions.get(:artist)[:nested].definitions.get(:band)[:nested].definitions
    Concrete.inspect.gsub(/\s/, "").must_equal 'Schema:{
    "links"=>#<Declarative::Definitions::Definition:@options={:render_nil=>true,:as=>"LINKS",:name=>"links"}>,
    "artist"=>#<Declarative::Definitions::Definition:@options={:render_nil=>true,:as=>"ARTIST",:cool=>true,:nested=>Schema:{
      "links"=>#<Declarative::Definitions::Definition:@options={:name=>"links"}>,
      "name"=>#<Declarative::Definitions::Definition:@options={:name=>"name"}>,
      "band"=>#<Declarative::Definitions::Definition:@options={:crazy=>nil,:nested=>Schema:{
        "links"=>#<Declarative::Definitions::Definition:@options={:name=>"links"}>,
        "location"=>#<Declarative::Definitions::Definition:@options={:name=>"location"}>},:name=>"band"}>},:name=>"artist"}>,
    "id"=>#<Declarative::Definitions::Definition:@options={:render_nil=>true,:as=>"ID",:unique=>true,:value=>1,:name=>"id"}>}'.
     gsub("\n", "").gsub(/\s/, "")
  end

  class InheritingConcrete < Concrete
    property :uuid
  end


  it do
    InheritingConcrete.extend(Declarative::Inspect::Schema)
    InheritingConcrete.inspect
    pp InheritingConcrete.definitions.get(:artist).options
    # pp InheritingConcrete.definitions.get(:artist)[:nested].definitions.get(:band)[:nested].definitions
    InheritingConcrete.inspect.gsub(/\s/, "").must_equal 'Schema:{
    "links"=>#<Declarative::Definitions::Definition:@options={:render_nil=>true,:as=>"LINKS",:name=>"links"}>,
    "artist"=>#<Declarative::Definitions::Definition:@options={:render_nil=>true,:as=>"ARTIST",:cool=>true,:nested=>Schema:{
      "links"=>#<Declarative::Definitions::Definition:@options={:name=>"links"}>,
      "name"=>#<Declarative::Definitions::Definition:@options={:name=>"name"}>,
      "band"=>#<Declarative::Definitions::Definition:@options={:crazy=>nil,:nested=>Schema:{
        "links"=>#<Declarative::Definitions::Definition:@options={:name=>"links"}>,
        "location"=>#<Declarative::Definitions::Definition:@options={:name=>"location"}>},:name=>"band"}>},:name=>"artist"}>,
    "id"=>#<Declarative::Definitions::Definition:@options={:render_nil=>true,:as=>"ID",:unique=>true,:value=>1,:name=>"id"}>,
    "uuid"=>#<Declarative::Definitions::Definition:@options={:render_nil=>true,:as=>"UUID",:name=>"uuid"}>}
     '.
     gsub("\n", "").gsub(/\s/, "")
  end
end