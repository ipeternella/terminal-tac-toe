# ------------------------------------------------------------------------
# This file contains some integration tests of the GameConfig module.
# ------------------------------------------------------------------------

require_relative "../classes/Game"
require "test/unit"

class TestTicTacToe < Test::Unit::TestCase

  def setup
    # default testing configurations
    @game = Game.new
    @game.board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @game.n = 3
    @game.p1_mark = "X"
    @game.p2_mark = "O"
    @game.difficulty = nil
    @game.game_type = nil
  end

  def test_get_board
    n = 4
    expected_board = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]

    assert_equal(@game.get_board(4), expected_board)
  end
  
end
