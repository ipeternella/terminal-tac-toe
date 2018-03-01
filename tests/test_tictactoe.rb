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

  def test_get_empty_spaces
    # marks spots with com_mark
    @board[0] = @game.com_mark

    # marks spots with hum_mark
    @board[1] = @game.hum_mark

    # expected available spaces
    as = ["2", "3", "4", "5", "6", "7", "8"]

    assert_equal(@game.get_available_spaces(@board), as)
  end

  # def test_get_game_difficulty
  #   puts "testing game difficulty... type 3"
    
  #   assert_equal(@game.get_game_difficulty, 3)
  # end

  def test_get_com_move
    # marks spots with com_mark
    @board[0] = @game.com_mark

    # marks spots with hum_mark
    @board[8] = @game.hum_mark

    # random_gen returns 7
    seed = 123
    
    assert_equal(@game.get_com_move(@board, 1, Random.new(seed)), 7)

    # marks spots with hum_mark in position 7
    @board[7] = @game.hum_mark

    assert_equal(@game.get_com_move(@board, 1, Random.new(seed)), 6)
  end

  def test_horizontal_scan_1
    # marks spots with hum_mark
    @board[0] = @game.hum_mark
    @board[1] = @game.hum_mark
    @board[2] = @game.com_mark

    assert_equal(@game.horizontal_scan(@board, 3), false)
  end

  def test_horizontal_scan_2
    # marks spots with hum_mark
    @board[0] = @game.hum_mark
    @board[1] = @game.hum_mark
    @board[3] = @game.hum_mark

    assert_equal(@game.horizontal_scan(@board, 3), false)
  end

  def test_horizontal_scan_3
    # marks spots with hum_mark
    @board[6] = @game.hum_mark
    @board[7] = @game.hum_mark
    @board[8] = @game.hum_mark

    assert_equal(@game.horizontal_scan(@board, 3), true)
  end
  
  def test_vertical_scan_1
    @board[0] = @game.hum_mark
    @board[3] = @game.hum_mark
    @board[6] = @game.hum_mark

    assert_equal(@game.vertical_scan(@board, 3), true)
  end

  def test_vertical_scan_2
    @board[2] = @game.hum_mark
    @board[5] = @game.hum_mark
    @board[8] = @game.hum_mark

    assert_equal(@game.vertical_scan(@board, 3), true)
  end

  def test_vertical_scan_3
    @board[1] = @game.hum_mark
    @board[4] = @game.hum_mark
    @board[7] = @game.hum_mark

    assert_equal(@game.vertical_scan(@board, 3), true)
  end

  def test_vertical_scan_4
    @board[1] = @game.hum_mark
    @board[4] = @game.com_mark
    @board[7] = @game.hum_mark

    assert_equal(@game.vertical_scan(@board, 3), false)
  end

  def test_vertical_scan_5
    @board[0] = @game.hum_mark
    @board[3] = @game.hum_mark
    @board[5] = @game.hum_mark

    assert_equal(@game.vertical_scan(@board, 3), false)
  end
  

  def test_diag_scan_1
    @board[0] = @game.hum_mark
    @board[4] = @game.hum_mark
    @board[8] = @game.hum_mark

    assert_equal(@game.diag_scan(@board, 3), true)
  end

  def test_diag_scan_2
    @board[2] = @game.hum_mark
    @board[4] = @game.hum_mark
    @board[6] = @game.hum_mark

    assert_equal(@game.diag_scan(@board, 3), true)
  end
  
end
