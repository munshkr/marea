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

    def inspect
      events = self.peek
      "#<Pattern #{events.empty? ? 'silence' : "[#{events.join(', ')}, ...]"}>"
    end
    alias_method :to_s, :inspect

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
      raise 'no block given' if block.nil?
      Pattern.new do |arc|
        self.call(arc.apply(&block))
      end
    end

    # Returns new pattern by applying +block+ to value
    #
    # @return [Pattern]
    #
    def with_event_value(&block)
      raise 'no block given' if block.nil?
      Pattern.new do |arc|
        self.call(arc).map do |ev|
          Event.new(block.call(ev.value), ev.whole, ev.part)
        end
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
      Pattern.oriented_merge(other_pattern, self, &block)
    end
    alias_method :<<, :left_merge

    # Merge with +other_pattern+ using structure from +other_pattern+
    #
    # @param other_pattern [Pattern, Object]
    # @return [Pattern]
    #
    def right_merge(other_pattern, &block)
      Pattern.oriented_merge(self, other_pattern, &block)
    end
    alias_method :>>, :right_merge

    def merge(other_pattern, &block)
      Pattern.merge(other_pattern, self, &block)
    end
    alias_method :|, :merge

    def +(o);  merge(o) { |a, b| a + b }; end
    def -(o);  merge(o) { |a, b| a - b }; end
    def *(o);  merge(o) { |a, b| a * b }; end
    def /(o);  merge(o) { |a, b| a / b }; end
    def %(o);  merge(o) { |a, b| a % b }; end
    def **(o); merge(o) { |a, b| a ** b }; end

    # Splits queries that span cycles.
    #
    # For example `query p (0.5, 1.5)` would be turned into two queries,
    # `(0.5,1)` and `(1,1.5)`, and the results combined.  Being able to assume
    # queries don't span cycles often makes transformations easier to specify.
    #
    # @return [Pattern]
    #
    def split_queries
      Pattern.new do |arc|
        arc.cycles_zero_width
          .map { |cycle_arc| self.call(cycle_arc) }
          .flatten(1)
      end
    end

    protected

    def self.merge(src, dst, &block)
      Pattern.new do |arc|
        res = []
        dst.p.call(arc).each do |event|
          src_events = src.p.call(event.part)
          src_events.each do |src_event|
            value = self.merge_event_value(event.value, src_event.value, &block)
            new_whole = src_event.whole.sub_arc(event.whole)
            new_part  = event.part.sub_arc(src_event.part)
            res << Event.new(value, new_whole, new_part)
          end
        end
        res
      end
    end

    def self.oriented_merge(src, dst, &block)
      Pattern.new do |arc|
        dst.p.call(arc).map do |event|
          # match with the onset (#whole.from)
          src_events = src.p.call(Arc.new(event.whole.from, event.whole.from))
          value = event.value.dup
          src_events.each do |src_event|
            value = self.merge_event_value(value, src_event.value, &block)
          end
          Event.new(value, event.whole, event.part)
        end
      end
    end

    # Returns merged value from other event
    #
    # @param other_event [Event]
    # @param block
    # @return [Object] a value
    #
    def self.merge_event_value(a, b, &block)
      a = a.dup
      b = b.dup
      block ||= lambda { |_, y| y }
      if a.is_a?(Hash) && b.is_a?(Hash)
        a.merge_values(b, &block)
      else
        block.call(a, b)
      end
    end
  end

  class P < Pattern; end
end
