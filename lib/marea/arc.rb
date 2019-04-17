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

    def inspect
      "#{@from}..#{@to}"
    end
    alias_method :to_s, :inspect

    # Split this arc into a list of arcs, at cycle boundaries
    #
    # @return [Array(Arc)]
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

    # Same as #cycles but returns also zero-widths arcs
    def cycles_zero_width
      @from == @to ? [self] : self.cycles
    end

    # Returns a list of arcs of the whole cycles that contain this arc
    #
    # @return [Array(Arc)]
    #
    def whole_cycles
      return [] if @from > @to
      from = @from.to_f.floor
      if @from == @to
        [Arc.new(from, from + 1)]
      else
        (from .. @to.to_f.ceil - 1).map { |t| Arc.new(t, t+1) }
      end
    end

    # Returns the intersection of two arcs
    #
    # @param other_arc [Arc]
    # @return [Arc]
    #
    def intersect(other_arc)
      Arc.new([@from, other_arc.from].max, [@to, other_arc.to].min)
    end

    # Similar to #intersection, but with some border cases regarding zero-width
    # arcs.
    #
    # Results might be zero-width except at the end of non-zero-width arcs
    # e.g. (0, 1) and (1, 2) do not intersect, but (1, 1) and (1, 1) does.
    #
    # @param o [Arc]
    # @return [Arc]
    #
    def sub_arc(o)
      sect = self.intersect(o)
      # FIXME Refactor condition
      return if (sect.from == sect.to && sect.from == self.to && self.from < self.to) ||
                (sect.from == sect.to && sect.from == o.to && o.from < o.to)
      return sect if sect.from <= sect.to
      nil
    end

    # Returns a new arc by applying +block+ to both +from+ and +to+
    #
    # @param block
    # @return [Arc]
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
