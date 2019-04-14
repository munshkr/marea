require "marea/pattern/generators"
require "marea/pattern/transformers"

module Marea
  class Pattern
    extend Generators
    include Transformers

    attr_reader :block

    def initialize(&block)
      raise 'no block given' if block.nil?
      @block = block
    end

    def call(from, to)
      @block.call(from, to)
    end

    def p
      self
    end

    # Returns new pattern by applying +block+ to both whole and part arcs of
    # all events
    #
    # @returns [Pattern]
    #
    def with_result_time(&block)
      raise 'no block given' if block.nil?

      Pattern.new do |from, to|
        self.call(from, to).map do |ev|
          Event.new(ev.value, ev.whole.apply(&block), ev.part.apply(&block))
        end
      end
    end

    # Returns new pattern by applying +block+ to query arc
    def with_query_time(&block)
      Pattern.new do |from, to|
        self.call(Arc.new(from, to).apply(&block))
      end
    end

    def split_queries
      Pattern.new do |from, to|
        Arc.new(from, to).cycles
          .map { |cycle| self.call(cycle.from, cycle.to) }
          .flatten(1)
      end
    end
  end

  class P < Pattern; end
end
