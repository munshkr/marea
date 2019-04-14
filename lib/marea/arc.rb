module Marea
  class Arc
    attr_reader :from, :to

    def initialize(from, to)
      @from = from.to_r
      @to = to.to_r

      if [@from, @to].any?(&:nil?)
        raise ArgumentError, "invalid range"
      end
    end

    # Creates a new Arc
    #
    # @see Arc#initialize
    #
    def self.[](*args)
      new(*args)
    end

    def inspect
      "Arc[#{@from}, #{@to}]"
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
      f = @from
      t = @to
      res = []
      while (f < t && f.floor != t.floor) do
        next_cycle = f.floor + 1
        res << Arc.new(f, next_cycle)
        f = next_cycle
      end
      res << Arc.new(f, t) if f < t && f.floor == t.floor
      res
    end

    # Returns a list of arcs of the whole cycles which are included in this arc
    #
    # @returns [Array(Arc)]
    #
    def whole_cycles
      f = @from.to_f.floor
      t = @to.to_f.ceil - 1
      (f..t).map { |t| Arc.new(t, t+1) }
    end

    # Returns a new arc by applying +block+ to both +from+ and +to+
    #
    # @param block
    # @returns [Arc]
    #
    def apply(&block)
      Arc.new(block.call(@from), block.call(@to))
    end

    # @private
    def ==(o)
      self.class == o.class &&
        @from == o.from &&
        @to == o.to
    end
  end
end
