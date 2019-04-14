module Marea
  class Pattern
    module Transformers
      def density(value)
        with_query_time { |t| t * value.to_r }
          .with_result_time { |t| t / value.to_r }
      end
      alias_method :fast, :density

      def sparsity(value)
        density(1 / value.to_r)
      end
      alias_method :slow, :sparsity
    end
  end
end
