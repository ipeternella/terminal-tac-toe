# ------------------------------------------------------------------------
# This class contains all the instance variables for the game state
# and contains methods to configure the game such as set the board size,
# the game difficulty, the game game type and to set the symbols used for
# player 1 and player 2 marks
# ------------------------------------------------------------------------

require_relative "../modules/MovementGetters"
require_relative "../modules/BoardScans"
require_relative "../modules/GameConfig"

class Game
  
  include MovementGetters    # module for getting human and computer moves
  include BoardScans         # module for scanning the board for ties and wins
  include GameConfig         # module for the game configuration

  # attribute accessor (testing)
  attr_accessor :board, :n, :p1_mark, :p2_mark, :difficulty, :game_type
  
  def initialize    
    @board      = nil    # string array with number indexes
    @n          = nil    # number of rows and cols of the board (rows = cols)
    @p1_mark    = nil    # player 1's mark (e.g., "X")
    @p2_mark    = nil    # player 2's mark (e.g., "O") - (may be another human or PC)
    @difficulty = nil    # game difficulty level (newbie, medium, hard)
    @game_type  = nil    # game type (player vs com, player vs player or com vs com)
  end

  def start_game
    # This function performs the game initialization and uses the GameConfig
    # module to set the game configurations such as the board size, players'
    # marks difficulty and game type.

    # puts a welcome msg to the player
    puts_welcome
    
    # gets the board size (number of rows/cols): min = 3, max = 5
    @n = get_board_size

    # intializes a board for the given size
    @board = get_board(@n)
            
    # gets the game type
    @game_type = get_game_type
    
    # gets the game marks for player 1 and player 2
    game_markers = get_game_markers    
    @p1_mark = game_markers[:p1_mark]
    @p2_mark = game_markers[:p2_mark]

    # gets the game difficulty but only when a computer is involved (options 1 or 3)
    case @game_type
    when 1, 3
      @difficulty = get_game_difficulty
    end

    # starts evaluating the board as the game goes on
    eval_board(@board, @n, @game_type, @difficulty, @p1_mark, @p2_mark)
  end
    
  def eval_board(board, n, game_type, difficulty, p1_mark, p2_mark)
    # This function controls the game flow based on game_type and difficulty
    # level. Essentially, it keeps reading human input and invoking functions
    # to compute the computer's next move until a tie or a victory happens.
    #
    # @argument board is a reference to the string array (board)
    # @argument n is the board size (number of rows/cols)
    # @argument difficulty is the difficulty level
    # @argument p1_mark is a string (single char) used as player 1's mark on the board
    # @argument p2_mark is a string (single char) used as player 2's mark on the board
        
    # initial printing of the board
    puts_board(board, n)

    # puts initial range to put numbers
    puts " *** Start by entering a number from [0-#{n * n - 1}]! *** "
    
    # listens to events based on game_type
    case game_type # game_type 1: player vs computer
    when 1
      # player vs computer
      loop do
        # gets human move (int index)
        hum_move = get_human_move(board, n, p1_mark, p2_mark)
        board[hum_move] = p1_mark

        # checks if game is over after player's move
        break if is_game_over(board, n, p1_mark, p2_mark)
        
        # computes next computer move (int index)
        com_move = get_com_move(board, n, difficulty, p2_mark, p1_mark)
        
        # sleeps
        sleep(1)
        
        board[com_move] = p2_mark

        # reprints the board after evaluation for the players
        puts_board(board, n)
        
        # checks if game is over after computer's move
        break if is_game_over(board, n, p1_mark, p2_mark)
        
      end
      
    when 2 # game_type: player vs player      
      loop do
        # gets human move (int index)
        hum_move = get_human_move(board, n, p1_mark, p2_mark)
        board[hum_move] = p1_mark
        
        # prints board after player 1's move
        puts_board(board, n)        
        
        # checks if game is over after player's move
        break if is_game_over(board, n, p1_mark, p2_mark)
        
        # gets other human move (int index)
        hum_move2 = get_human_move(board, n, p2_mark, p1_mark)
        board[hum_move2] = p2_mark

        # prints board after player 2's move
        puts_board(board, n)        
        
        # checks if game is over after player's move
        break if is_game_over(board, n, p1_mark, p2_mark)
                
      end
        
    when 3 # game_type: computer vs computer
      loop do
        # computes computer 1's move
        com_move = get_com_move(board, n, difficulty, p1_mark, p2_mark)
        board[com_move] = p1_mark
        
        # prints board after move
        puts_board(board, n)        
        
        # checks if game the is over
        break if is_game_over(board, n, p1_mark, p2_mark)

        # delay for player to watch the moves
        sleep(4)
        
        # computes computer 2's movement
        com_move2 = get_com_move(board, n, difficulty, p2_mark, p1_mark)
        board[com_move2] = p2_mark
        
        # prints board after move
        puts_board(board, n)
        
        # checks if game is over
        break if is_game_over(board, n, p1_mark, p2_mark)
        
      end
      
    end

    # final message for the user
    puts " *** GAME OVER *** "
    
  end
  
  def is_game_over(board, n, p1_mark, p2_mark)
    # This function uses the BoardScans module to perform several board scans
    # to see if a player has won (vertically, horizontally or diagonally)
    # or if the game is a tie.
    #
    # @argument board is a reference to the string array (board)
    # @argument n is the board size (number of rows/cols)
    # @argument p1_mark is a string (single char) used as player 1's mark on the board
    # @argument p2_mark is a string (single char) used as player 2's mark on the board
    #
    # @return true or false
    
    return vertical_scan(board, n) || horizontal_scan(board, n) || diag_scan(board, n) || tie(board, p1_mark, p2_mark)
  end
  
  def puts_board(board, n)
    # This function reads the string array (board) and prints it
    # in a pretty way for the players.
    #
    # @argument board is a reference to the string array (board)
    # @argument n is the board size (number of rows/cols)

    # space before
    puts ""
    
    ncol = n
    nrow = n
    index = 0

    while nrow > 1
      # prints row cells
      while ncol > 1
        print_cell(board, index, false)

        index += 1
        ncol -= 1
      end

      # prints last cell of the line
      print_cell(board, index, true)
      
      index += 1
      ncol = n

      # prints horizontal bars
      print_horizontal_bars(ncol)
      
      ncol = n
      nrow -= 1
    end

    # prints last row
    while ncol > 1
      print_cell(board, index, false)
      
      index += 1
      ncol -= 1
    end

    # last col
    print_cell(board, index, true)

    # space after the board
    puts ""    
  end

  def print_cell(board, index, is_end_of_line)
    # This function is used to print a single cell of the board (e.g., '2 | 3 | 4').
    # Board numbers with only 1 digit (e.g., 7) gets 2 spaces before being print whereas board
    # numbers with 2 digits (e.g., 15) gets 1 space before being print in order to display
    # an organized board for the user (proper spacing is essential when printing the board).
    # Also, players' marks are 1 char long so they get 2 spaces before being print.
    #
    # @argument board is a reference to the string array (board).
    # @argument index int required which represents each number on the string array.
    # @argument is_end_of_line is a boolean that determines whether this function should print
    # a cell or the last cell (which requires different printing).
    
    if !is_end_of_line
      # 2 spaces before the board number (1 digit only) or
      # 2 spaces before a player's mark (1 char only)
      if (index <= 9) || !is_valid_number(board[index])
        print "  #{board[index]} |"
      else
        # 1 space before board numbers with 2 digits
        print " #{board[index]} |" 
      end
    else
      # last cell of the board is different: no '|' and requires '\n'

      # 2 spaces before numbers with 1 digit or a player's mark
      if (index <= 9)  || !is_valid_number(board[index])
        print "  #{board[index]}\n"
      else
        # 1 space for numbers with 2 digits
        print " #{board[index]}\n"
      end
      
    end    
  end

  def print_horizontal_bars(ncol)
    # This function prints the horizontal bars of the board (e.g., '===+===+===').
    # 
    # @argument ncol is the number of cols,
    
    # prints horizontal bars for every column EXCEPT the last one (different)
    while ncol > 1
      print "====+"
      ncol -= 1
    end
    
    # prints horizontal bar for the last cell of the row (has no '+' and requires '\n')
    print "====\n"    
  end
    
end
