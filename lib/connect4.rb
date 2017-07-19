require "connect4/version"
require "connect4/game"
require "connect4/player"

module Connect4
  extend self

  def play
    Game.new(Player.new(color: :r),
             Player.new(color: :b))
  end
end
