require "test_helper"
require "declarative/schema"

class SchemaTest < Minitest::Spec


  class Decorator
    extend Declarative::Schema::DSL

    def self.default_nested_class
      self
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
    Decorator.extend(Inspect::Schema)
    Decorator.inspect
    # pp Decorator.definitions.extend(Definitions::Inspect)
    pp Decorator.inspect
  end
end