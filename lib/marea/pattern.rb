require "marea/pattern/generators"

module Marea
  class Pattern
    extend Generators

    attr_reader :block

    def initialize(&block)
      raise 'no block given' if block.nil?
      @block = block
    end

    def call(arc)
      @block.call(arc)
    end

    def with_result_time(&block)
      raise 'no block given' if block.nil?

      self.class.new do |arc|
        self.call(arc).map do |ev|
          Event.new(ev.whole.apply(&block), ev.part.apply(&block), ev.value)
        end
      end
    end

    def split_queries
      self.class.new do |arc|
        arc.cycles.map { |cycle| self.call(cycle) }
      end
    end
  end

  class P < Pattern; end
end
