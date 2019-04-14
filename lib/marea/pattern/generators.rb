module Marea
  class Pattern
    module Generators
      def pure(value)
        Pattern.new do |arc|
          Arc.new(arc).whole_cycles.map { |a| Event.new(value, a, a) }
        end
      end

      def silence
        Pattern.new { [] }
      end

      def cat(array)
        pattern = Pattern.new do |arc|
          l = array.size
          r = arc.begin.floor
          n = r % l
          p = self.pure(array[n])

          offset = r - ((r - n) / l)
          p.with_result_time { |t| t + offset }
            .call((arc.begin - offset)..(arc.end - offset))
        end
        pattern.split_queries
      end
    end
  end
end
