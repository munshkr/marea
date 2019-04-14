module Marea::CoreExt
  module Float
    # Safe version of #to_r
    def to_r
      to_s.to_r
    end
  end
end

class Float
  prepend Marea::CoreExt::Float
end
