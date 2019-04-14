module Marea::CoreExt
  module Range
    def to_arc
      Arc.new(self)
    end
  end
end

class Range
  include Marea::CoreExt::Range
end
