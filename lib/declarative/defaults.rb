require "uber/delegates"

module Declarative
  class Defaults
    def initialize
      @static_options  = {}
      @dynamic_options = ->(*) { Hash.new }
    end

    def merge!(hash, &block)
      @static_options.merge!(hash) if hash.any?
      @dynamic_options = block if block_given?
      self
    end

    extend Uber::Delegates
    delegates :@static_options, :[], :[]= # mutuable API!

    # TODO: allow to receive rest of options/block in dynamic block. or, rather, test it as it was already implemented.
    def call(name, given_options)
      options = @static_options
      options = options.merge(@dynamic_options.(name, given_options))
      options = options.merge(given_options)
    end
  end
end
