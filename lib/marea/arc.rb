module Marea
  class Arc
    attr_reader :from, :to

    def initialize(range)
      @from = range.begin
      @to = range.end
    end

    def inspect
      "A[#{@from}..#{@to}]"
    end
    alias_method :to_s, :inspect
  end
end
