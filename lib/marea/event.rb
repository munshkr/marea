module Marea
  class Event
    attr_reader :value
    attr_reader :whole
    attr_reader :part

    # Creates a new Event given a +value+, and +whole+ and +part+ ranges
    #
    # @param value [Object]
    # @param whole [Range(Fixnum)] (default: 0..1)
    # @param part [Range(Fixnum)] (default: 0..1)
    # @return [Event]
    #
    def initialize(value, whole=nil, part=nil)
      @value = value
      @whole = whole || (0..1)
      @part = part || (0..1)
    end

    # Creates a new Event
    #
    # @see Event#initialize
    #
    def self.[](*args)
      new(*args)
    end

    # Returns a string containing a human-readable representation
    #
    # This string usually is valid Ruby, and can be evaluated to construct the
    # same instance.
    #
    # @return [String]
    #
    def inspect
      "Event[#{@value.inspect}, #{@whole}, #{@part}]"
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
