module Marea::CoreExt
  module Array
    def p
      Pattern.cat(self)
    end
  end
end

class Array
  include Marea::CoreExt::Array
end
