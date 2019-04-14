module Marea
  class Pattern
    module Generators
      def pure(value)
        Pattern.new do |from, to|
          Arc.new(from, to).whole_cycles.map do |arc|
            Event.new(value, arc, arc)
          end
        end
      end

      def silence
        Pattern.new { [] }
      end

      def cat(array)
        pattern = Pattern.new do |from, to|
          l = array.size
          r = from.floor
          n = r % l
          p = self.pure(array[n])

          offset = r - ((r - n) / l)
          p.with_result_time { |t| t + offset }
            .call(from - offset, to - offset)
        end
        pattern.split_queries
      end
    end
  end
end
