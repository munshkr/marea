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

    def call(arc)
      @block.call(arc)
    end

    def p
      self
    end

    # Returns pattern by applying +block+ to both whole and part arcs of all
    # events
    #
    # @returns [Pattern]
    #
    def with_result_time(&block)
      raise 'no block given' if block.nil?

      Pattern.new do |arc|
        self.call(arc).map do |ev|
          Event.new(ev.value, ev.whole.apply(&block), ev.part.apply(&block))
        end
      end
    end

    def with_query_time(&block)
      Pattern.new do |arc|
        self.call(arc.apply(&block))
      end
    end

    def split_queries
      Pattern.new do |arc|
        arc.cycles.map { |cycle| self.call(cycle) }.flatten(1)
      end
    end
  end

  class P < Pattern; end
end
