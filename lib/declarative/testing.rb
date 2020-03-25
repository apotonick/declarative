module Declarative
  def self.Inspect(obj)
    obj.inspect
  end

  module Inspect
    def inspect
      string = super
      if is_a?(Proc)
        elements = string.split(/[:@ ]/)
        elements[2] = '@' + File.basename(elements[2])
        elements.delete_at(1)
        string = elements.join(':')
      end
      string.gsub(/0x\w+/, "")
    end

    module Schema
      def inspect
        definitions.extend(Definitions::Inspect)
        "Schema: #{definitions.inspect}"
      end
    end
  end

  module Definitions::Inspect
    def inspect
      each { |dfn|
        dfn.extend(Declarative::Inspect)

        if dfn[:nested] && dfn[:nested].is_a?(Declarative::Schema::DSL)
          dfn[:nested].extend(Declarative::Inspect::Schema)
        else
          dfn[:nested].extend(Declarative::Definitions::Inspect) if dfn[:nested]
        end
      }
      super
    end

    def get(*)
      super.extend(Declarative::Inspect)
    end
  end
end
