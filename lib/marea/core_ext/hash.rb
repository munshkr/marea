module Marea::CoreExt
  module Hash
    def merge_values(src, &block)
      block ||= lambda { |_, y| y }
      dst = self.clone
      src.each do |k, v|
        dst[k] = if dst[k].nil? || v.nil?
          v
        else
          block.call(dst[k], v)
        end
      end
      dst
    end
  end
end

class Hash
  include Marea::CoreExt::Hash
end
