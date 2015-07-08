require "test_helper"

class PropertyTest < Minitest::Spec
  it do
    schema = Class.new(Representable::Decorator)
    schema.property :artist do
      property :name

      def self.clone
        raise
      end
    end

    inherited = Class.new(schema)

    inherited.representable_attrs.get(:artist).representer_module.wont_equal schema.representable_attrs.get(:artist).representer_module
  end
end
