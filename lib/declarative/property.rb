module Declarative
  module Property
    # options.dup
    def property(name, options={}, &block)
      declarative_attrs[:property] ||= []
      declarative_attrs[:property] << {args: [name, options.dup], block: block}
    end
  end
end