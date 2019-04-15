module Marea
  class Event
    attr_reader :value
    attr_reader :whole
    attr_reader :part

    # Creates a new Event given a +value+, and +whole+ and +part+ ranges
    #
    # @param value [Object]
    # @param whole [Arc] (default: Arc[0, 1])
    # @param part [Arc] (default: Arc[0, 1])
    # @return [Event]
    #
    def initialize(value, whole=nil, part=nil)
      @value = value
      @whole = whole || Arc.new(0, 1)
      @part = part || Arc.new(0, 1)
    end

    # Returns a string containing a human-readable representation
    #
    # This string usually is valid Ruby, and can be evaluated to construct the
    # same instance.
    #
    # @return [String]
    #
    def inspect
      "<#{@value.inspect} #{@whole} #{@part}>"
    end
    alias_method :to_s, :inspect

    # @private
    def ==(o)
      self.class == o.class &&
        @whole == o.whole &&
        @part == o.part &&
        @value == o.value
    end
  end
end
