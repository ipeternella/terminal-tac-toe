# ------------------------------------------------------------------------
# This file contains some integration tests of the BoardScans module.
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
  
  def test_horizontal_scan_1
    # fills one line but with different player marks
    @game.board[0] = @game.p1_mark
    @game.board[1] = @game.p1_mark
    @game.board[2] = @game.p2_mark

    assert_equal(@game.horizontal_scan(@game.board, @game.n), false)
  end

  def test_horizontal_scan_2
    @game.board[6] = @game.p1_mark
    @game.board[7] = @game.p1_mark
    @game.board[8] = @game.p1_mark

    assert_equal(@game.horizontal_scan(@game.board, @game.n), true)
  end

  def test_vertical_scan_1
    @game.board[2] = @game.p1_mark
    @game.board[5] = @game.p2_mark
    @game.board[8] = @game.p1_mark

    assert_equal(@game.vertical_scan(@game.board, @game.n), false)
  end

  def test_vertical_scan_2
    @game.board[2] = @game.p2_mark
    @game.board[5] = @game.p2_mark
    @game.board[8] = @game.p2_mark

    assert_equal(@game.vertical_scan(@game.board, @game.n), true)
  end

  def test_diagonal_scan_1
    @game.board[0] = @game.p2_mark
    @game.board[4] = @game.p2_mark
    @game.board[8] = @game.p2_mark

    assert_equal(@game.diag_scan(@game.board, @game.n), true)
  end

  def test_diagonal_scan_2
    @game.board[2] = @game.p1_mark
    @game.board[4] = @game.p1_mark
    @game.board[6] = @game.p1_mark

    assert_equal(@game.diag_scan(@game.board, @game.n), true)
  end

  def test_diagonal_scan_3
    @game.board[2] = @game.p1_mark
    @game.board[4] = @game.p2_mark
    @game.board[6] = @game.p2_mark

    assert_equal(@game.diag_scan(@game.board, @game.n), false)
  end

  def test_tie
    # fills one line but with different player marks
    @game.board = [@game.p1_mark, @game.p2_mark, @game.p1_mark,
                   @game.p1_mark, @game.p2_mark, @game.p2_mark,
                   @game.p1_mark, @game.p1_mark, @game.p2_mark]

    assert_equal(@game.tie(@game.board, @game.p1_mark, @game.p2_mark), true)
  end
  
end
