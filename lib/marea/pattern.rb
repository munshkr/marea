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

    # Returns new pattern by applying +block+ to both whole and part arcs of
    # all events
    #
    # @return [Pattern]
    #
    def with_result_time(&block)
      raise 'no block given' if block.nil?

      Pattern.new do |arc|
        self.call(arc).map do |ev|
          Event.new(ev.value, ev.whole.apply(&block), ev.part.apply(&block))
        end
      end
    end

    # Returns new pattern by applying +block+ to query arc
    #
    # @return [Pattern]
    #
    def with_query_time(&block)
      Pattern.new do |arc|
        self.call(arc.apply(&block))
      end
    end

    # Evaluates pattern from 0 to +to+, as a preview of resulting events
    #
    # @param to [Rational] (default: 1)
    # @return [Array(Event)]
    #
    def peek(to=1)
      self.call(Arc.new(0, to))
    end

    # Merge with +other_pattern+ using structure from +self+
    #
    # @param other_pattern [Pattern, Object]
    # @return [Pattern]
    #
    def left_merge(other_pattern, &block)
      oriented_merge(other_pattern, &block)
    end
    alias_method :<<, :left_merge

    # Merge with +other_pattern+ using structure from +other_pattern+
    #
    # @param other_pattern [Pattern, Object]
    # @return [Pattern]
    #
    def right_merge(other_pattern, &block)
      oriented_merge(other_pattern, invert=true, &block)
    end
    alias_method :>>, :right_merge

    # @private
    def split_queries
      Pattern.new do |arc|
        arc.cycles
          .map { |cycle_arc| self.call(cycle_arc) }
          .flatten(1)
      end
    end

    protected

    def oriented_merge(other_pattern, invert=false, &block)
      block ||= lambda { |a, b| b }
      src, dst = invert ? [self, other_pattern] : [other_pattern, self]
      Pattern.new do |arc|
        dst.p.call(arc).map do |event|
          # match with the onset (#whole.from)
          src_events = src.p.call(Arc.new(event.whole.from, event.whole.from))
          value = event.value.dup
          src_events.each do |src_event|
            value = block.call(value, src_event.value)
          end
          Event.new(value, event.whole, event.part)
        end
      end
    end
  end

  class P < Pattern; end
end
