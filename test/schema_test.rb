require "test_helper"
require "declarative/schema"

class SchemaTest < Minitest::Spec
  class Decorator
    extend Declarative::Schema::DSL
    extend Declarative::Schema::Feature # TODO: make automatic

    def self.default_nested_class
      Decorator
    end
  end

  module AddLinks
    def self.included(includer)
      includer.property(:links)
      #includer.definitions.each { |name, dfn| dfn.options[:added] = true }
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
    Concrete.extend(Inspect::Schema)
    Concrete.inspect
    pp Concrete.definitions.get(:artist).options
    # pp Concrete.definitions.get(:artist)[:nested].definitions.get(:band)[:nested].definitions
    Concrete.inspect.gsub(/\s/, "").must_equal 'Schema: {
    "links"=>#<Declarative::Definitions::Definition: @options={:render_nil=>true, :as=>"LINKS"}, @name="links">,
    "artist"=>#<Declarative::Definitions::Definition: @options={:render_nil=>true, :as=>"ARTIST", :cool=>true, :nested=>
      Schema: {
        "links"=>#<Declarative::Definitions::Definition: @options={}, @name="links">,
        "name"=>#<Declarative::Definitions::Definition: @options={}, @name="name">,
        "band"=>#<Declarative::Definitions::Definition: @options={:crazy=>nil, :nested=>
          Schema: {
            "links"=>#<Declarative::Definitions::Definition: @options={}, @name="links">,
            "location"=>#<Declarative::Definitions::Definition: @options={}, @name="location">}}, @name="band">}}, @name="artist">,
     "id"=>#<Declarative::Definitions::Definition: @options={:render_nil=>true, :as=>"ID", :unique=>true, :value=>1}, @name="id">}'.
     gsub("\n", "").gsub(/\s/, "")
  end
end