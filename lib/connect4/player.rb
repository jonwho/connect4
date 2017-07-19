module Connect4
  class Player
    attr_accessor :color, :won

    def initialize(options)
      @won = false
      @color = options[:color]
    end

    def won?
      won
    end
  end
end
