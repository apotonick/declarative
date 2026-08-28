# frozen_string_literal: true

module Declarative
  module DeepDup
    def self.call(args)
      case args
      when Array
        dup_items(args)
      when ::Hash
        result = {}
        args.each_pair { |key, value| result[call(key)] = call(value) }
        result
      else
        args

      end
    end

    def self.dup_items(arr)
      arr.to_a.collect { |v| call(v) }
    end
  end
end
