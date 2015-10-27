require "test_helper"
require "declarative/schema"

class SchemaTest < Minitest::Spec
  class Decorator
    extend Declarative::Schema::DSL

    def self.default_nested_class
      Decorator
    end
  end

  class Concrete < Decorator
    defaults render_nil: true do |name|
      { as: name.to_s.upcase }
    end

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
    # pp Concrete.definitions.extend(Definitions::Inspect)
    pp Concrete.inspect
    Concrete.inspect.must_equal 'Schema: {"artist"=>#<Declarative::Definitions::Definition: @options={:render_nil=>true, :as=>"ARTIST", :cool=>true, :nested=>Schema: {"name"=>#<Declarative::Definitions::Definition: @options={}, @name="name">, "band"=>#<Declarative::Definitions::Definition: @options={:crazy=>nil, :nested=>Schema: {"location"=>#<Declarative::Definitions::Definition: @options={}, @name="location">}}, @name="band">}}, @name="artist">, "id"=>#<Declarative::Definitions::Definition: @options={:render_nil=>true, :as=>"ID", :unique=>true, :value=>1}, @name="id">}'
  end
end