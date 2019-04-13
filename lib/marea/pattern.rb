module Marea
  class Pattern
    def initialize(&block)
      raise 'no block given' unless block_given?
      @block = block
    end

    def call(arc)
      @block.call(arc)
    end
  end

  class P < Pattern; end
end
