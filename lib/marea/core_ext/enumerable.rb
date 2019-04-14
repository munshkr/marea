module Marea::CoreExt
  module Enumerable
    def p
      Pattern.cat(self.to_a)
    end
  end
end

class Enumerator
  include Marea::CoreExt::Enumerable
end

class Range
  include Marea::CoreExt::Enumerable
end
