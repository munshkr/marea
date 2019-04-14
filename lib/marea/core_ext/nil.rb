module Marea::CoreExt
  module Nil
    def p
      Pattern.silence
    end
  end
end

class NilClass
  include Marea::CoreExt::Nil
end
