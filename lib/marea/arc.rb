module Marea
  class Arc
    attr_reader :begin, :end

    def initialize(range_or_arc)
      @begin = range_or_arc.begin.to_r
      @end = range_or_arc.end.to_r

      if [@begin, @end].any?(&:nil?)
        raise ArgumentError, "invalid range"
      end
    end

    # Creates a new Arc
    #
    # @see Arc#initialize
    #
    def self.[](range)
      new(range)
    end

    def inspect
      "Arc[#{@begin}..#{@end}]"
    end
    alias_method :to_s, :inspect

    def to_arc
      self
    end

    # Split this arc into a list of arcs, at cycle boundaries
    #
    # @returns [Array(Arc)]
    #
    def cycles
      b = @begin
      e = @end
      res = []
      while (b < e && b.floor != e.floor) do
        next_cycle = b.floor + 1
        res << Arc.new(b..next_cycle)
        b = next_cycle
      end
      res << Arc.new(b..e) if b < e && b.floor == e.floor
      res
    end

    # Returns a list of arcs of the whole cycles which are included in this arc
    #
    # @returns [Array(Arc)]
    #
    def whole_cycles
      s = @begin.to_f.floor
      e = @end.to_f.ceil - 1
      (s..e).map { |t| Arc.new(t..(t+1)) }
    end

    # Returns a new arc by applying +block+ to both +begin+ and +end+
    #
    # @param block
    # @returns [Arc]
    #
    def apply(&block)
      Arc.new(block.call(@begin)..block.call(@end))
    end

    # @private
    def ==(o)
      self.class == o.class &&
        @begin == o.begin &&
        @end == o.end
    end
  end
end
