module Marea
  class Pattern
    module Generators
      def pure(value)
        Pattern.new do |arc|
          arc.whole_cycles.map do |cycle_arc|
            part_arc = arc.intersect(cycle_arc)
            Event.new(value, cycle_arc, part_arc)
          end
        end
      end

      def silence
        Pattern.new { [] }
      end

      def cat(array)
        pattern = Pattern.new do |arc|
          l = array.size
          r = arc.from.floor
          n = r % l
          p = self.pure(array[n])

          offset = r - ((r - n) / l)

          p.with_result_time { |t| t + offset }
            .call(Arc.new(arc.from - offset, arc.to - offset))
        end
        pattern.split_queries
      end
    end
  end
end
