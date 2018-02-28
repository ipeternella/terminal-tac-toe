require_relative "../tictactoe"
require "test/unit"

class TestTicTacToe < Test::Unit::TestCase

  def setup
    @game = Game.new
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
  end
  
  def test_spot_validation
    # tests for proper spot validation
    max_spot = @game.size ** 2 - 1
    min_spot = 0
    negative_spot = -10
    too_high_spot = max_spot + 1
    invalid_int = 'hello'

    assert_equal(@game.is_valid_spot(max_spot, @board), true)
    assert_equal(@game.is_valid_spot(min_spot, @board), true)

    # spot out of bounds testing
    assert_equal(@game.is_valid_spot(negative_spot, @board), false)
    assert_equal(@game.is_valid_spot(too_high_spot, @board), false)

    # invalid int testing
    assert_equal(@game.is_valid_spot(invalid_int, @board), false)
  end

  def test_spot_validation_board    
    # marks spots with com_mark
    @board[0] = @game.com_mark

    # marks spots with hum_mark
    @board[1] = @game.hum_mark
    
    assert_equal(@game.is_valid_spot(0, @board), false)
    assert_equal(@game.is_valid_spot(1, @board), false)

    # no marker test
    assert_equal(@game.is_valid_spot(2, @board), true)

    # marks spots with hum_mark
    @board[2] = @game.hum_mark
    
    # after setting mark
    assert_equal(@game.is_valid_spot(2, @board), false)
  end
  
  
end
