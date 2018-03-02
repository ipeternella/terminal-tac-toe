# ------------------------------------------------------------------------
# This file contains some integration tests of the MovementGetters module.
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
    @game.difficulty = 1
    @game.game_type = 1
  end
  
  def test_spot_validation
    # tests for proper spot validation
    max_spot = @game.n ** 2 - 1
    min_spot = 0
    negative_spot = -10
    too_high_spot = max_spot + 1
    invalid_int = 'hello'

    assert_equal(@game.is_valid_spot(max_spot, @game.board, @game.n, @game.p1_mark, @game.p2_mark), true)
    assert_equal(@game.is_valid_spot(min_spot, @game.board, @game.n, @game.p1_mark, @game.p2_mark), true)

    # spot out of bounds testing
    assert_equal(@game.is_valid_spot(negative_spot, @game.board, @game.n, @game.p1_mark, @game.p2_mark), false)
    assert_equal(@game.is_valid_spot(too_high_spot, @game.board, @game.n, @game.p1_mark, @game.p2_mark), false)

    # invalid int testing
    assert_equal(@game.is_valid_spot(invalid_int, @game.board, @game.n, @game.p1_mark, @game.p2_mark), false)
  end

  def test_spot_validation_board 
    # marks spots with p2_mark
    @game.board[0] = @game.p2_mark

    # marks spots with p1_mark
    @game.board[1] = @game.p1_mark
    
    assert_equal(@game.is_valid_spot(0, @game.board, @game.n, @game.p1_mark, @game.p2_mark), false)
    assert_equal(@game.is_valid_spot(1, @game.board, @game.n, @game.p1_mark, @game.p2_mark), false)

    # no marker test
    assert_equal(@game.is_valid_spot(2, @game.board, @game.n, @game.p1_mark, @game.p2_mark), true)

    # marks more spots with p1_mark
    @game.board[2] = @game.p1_mark
    
    # after setting mark
    assert_equal(@game.is_valid_spot(2, @game.board, @game.n, @game.p1_mark, @game.p2_mark), false)
  end

  def test_get_empty_spaces
    # marks spots with player 1 mark
    @game.board[0] = @game.p1_mark

    # marks spots with player 2 mark
    @game.board[8] = @game.p2_mark

    # expected available spaces
    as = ["1", "2", "3", "4", "5", "6", "7"]

    assert_equal(@game.get_available_spaces(@game.board, @game.p1_mark, @game.p2_mark), as)
  end
  
  def test_get_com_move
    # marks spots 
    @game.board = ["0", "1", "2", "3", "4", @game.p2_mark, @game.p1_mark, "7", "8"]
    @game.difficulty = 2
    
    # asserts expected as 
    as = ["0", "1", "2", "3", "4", "7", "8"]
    assert_equal(@game.get_available_spaces(@game.board, @game.p1_mark, @game.p2_mark), as)

    seed = 123
    random_gen = Random.new(seed)  
    random_gen2 = Random.new(seed) # required a second generator because the first will already have triggered its first number
    
    # since there are only 5 available spaces, random_gen must generate an index from 0 .. 5 (one of the empty indexes)
    assert_equal(@game.get_com_move(@game.board, @game.n, @game.difficulty, random_gen, @game.p1_mark, @game.p2_mark), as[random_gen2.rand(0 .. as.length - 1)].to_i)

    # marks spots with p1_mark in position 7, forcing the pc to block it by moving in spot 8
    @game.board[7] = @game.p1_mark

    # asserts computer blocks the other player
    assert_equal(@game.get_com_move(@game.board, @game.n, @game.difficulty, random_gen, @game.p1_mark, @game.p2_mark), 8)
  end

  def test_get_random_move
    # sets seed for a random generator
    seed = 123
    random_gen = Random.new(seed=seed)

    as = @game.get_available_spaces(@game.board,@game.p1_mark, @game.p2_mark) 
    
    # board is all empty (no marks) so random_gen should generate random from 0 .. 8 (all indexes are free)    
    assert_equal(@game.get_random_move(@game.board, random_gen, @game.p1_mark, @game.p2_mark), as[random_gen.rand(0 .. 8)].to_i)
  end
  
end
