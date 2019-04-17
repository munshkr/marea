module Marea::CoreExt
  module Hash
    def p
      pat = nil
      self.each do |key, value|
        new_pat = value.p.with_event_value { |v| {key => v} }
        pat = pat.nil? ? new_pat : pat.merge(new_pat)
      end
      pat
    end

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

    def |(o);  self.p | o; end
    def +(o);  self.p + o; end
    def -(o);  self.p - o; end
    def *(o);  self.p * o; end
    def /(o);  self.p / o; end
    def %(o);  self.p % o; end
    def **(o); self.p ** o; end
  end
end

class Hash
  include Marea::CoreExt::Hash
end
