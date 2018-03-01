require_relative "./classes/Game"

TEST = false

if !TEST
  game = Game.new
  game.start_game
else
  # testing
end
