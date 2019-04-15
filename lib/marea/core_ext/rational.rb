module Marea::CoreExt
  module Rational
    def inspect
      if denominator == 1
        numerator.inspect
      else
        super
      end
    end

    def to_s
      inspect
    end
  end
end

class Rational
  prepend Marea::CoreExt::Rational
end
