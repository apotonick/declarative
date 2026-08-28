# frozen_string_literal: true

module Declarative
  module DeepDup
    def self.call(args)
      case args
      when Array
        dup_items(args)
      when ::Hash
        copy = ::Hash[dup_items(args)]
        if Hash.respond_to?(:ruby2_keywords_hash?) && Hash.ruby2_keywords_hash?(args)
          copy = Hash.ruby2_keywords_hash(copy)
        end
        copy
      else
        args

      end
    end

    def self.dup_items(arr)
      arr.to_a.collect { |v| call(v) }
    end
  end
end
