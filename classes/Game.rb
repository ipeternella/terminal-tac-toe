require_relative "../modules/MovementGetters"
require_relative "../modules/BoardScans"
require_relative "../modules/GameConfig"

class Game

  # mixins to add new methods to the game class
  include MovementGetters
  include BoardScans
  include GameConfig

  # attribute readers
  attr_reader :n, :com_mark, :hum_mark, :board
  
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"] # contents = str, indexes = board
    @n = 4             # number of rows and cols of the board
    @p1_mark = "X"    # the computers marker
    @p2_mark = "O"    # the users marker
    @difficulty = nil  # game difficulty level
    @game_type = nil   # game type: player vs com, player vs player or com vs com
  end

  def start_game
    
    @n = get_board_size
    @board = get_board(@n)    
    #puts_board2(@board, @n)
    
    # puts welcome msg to the player
    puts_welcome
    
    # asks for game type
    @game_type = get_game_type
    
    # game markers customization
    game_markers = get_game_markers
    @p1_mark = game_markers[:p1_mark]
    @p2_mark = game_markers[:p2_mark]
        
    case @game_type
    when 1, 3
      # gets pc difficulty only when a computer is involved
      @difficulty = get_game_difficulty
    end
    
    eval_board(@board, @n, @game_type, @difficulty, @p1_mark, @p2_mark)
  end
    
  def eval_board(board, n, game_type, difficulty, p1_mark, p2_mark)
    
    # initial printing of the board
    puts_board(board, n)
    puts "enter [0-8]:"
    
    # game events based on game_type: com vs com, player vs com...
    case game_type           
    when 1
      # player vs computer
      loop do
        # gets human move (int)
        hum_move = get_human_move(board, p1_mark, p2_mark)
        board[hum_move] = p1_mark

        # checks if game is over
        break if is_game_over(board, n, p1_mark, p2_mark)
        
        # gets computer move
        com_move = get_com_move(board, difficulty, p2_mark, p1_mark)
        board[com_move] = p2_mark

        # checks if game is over
        break if is_game_over(board, n, p1_mark, p2_mark)

        # as = get_available_spaces(board)
        # puts "AFTER PC MOVE: #{as}"

        # reprint the board after evaluation
        puts_board(board, n)
        
      end

      # final board printing
      puts_board(board, n)        
      
    when 2
      # player vs player
      loop do
        # gets human move (int)
        hum_move = get_human_move(board, p1_mark, p2_mark)
        board[hum_move] = p1_mark
        
        # prints p1 move
        puts_board(board, n)        
        
        # checks if game is over
        break if is_game_over(board, n, p1_mark, p2_mark)
        
        # gets computer move
        hum_move2 = get_human_move(board, p2_mark, p1_mark)
        board[hum_move2] = p2_mark
        
        # checks if game is ove
        break if is_game_over(board, n, p1_mark, p2_mark)
        
        # reprint the board after evaluation
        puts_board(board, n)
        
      end

      # final board printing
      puts_board(board, n)        
        
    when 3
      # computer vs computer
      loop do
        # pc1 movement
        com_move = get_com_move(board, difficulty, p1_mark, p2_mark)
        board[com_move] = p1_mark
        
        # prints p1 move
        puts_board(board, n)        
        
        # checks if game is over
        break if is_game_over(board, n, p1_mark, p2_mark)
        
        # pc2 movement
        com_move2 = get_com_move(board, difficulty, p2_mark, p1_mark)
        board[com_move2] = p2_mark
        
        # checks if game is ove
        break if is_game_over(board, n, p1_mark, p2_mark)

        # reprint the board after evaluation
        puts_board(board, n)
        
      end
    end

    puts "Game over"
    
  end
  
  def is_game_over(board, n, p1_mark, p2_mark)
    return vertical_scan(board, n) || horizontal_scan(board, n) || diag_scan(board, n) || tie(board, p1_mark, p2_mark)
  end
  
  # def puts_board(board)
  #   puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
  #   #puts "Enter [0-8]:"
  # end

  def puts_board(board, n)
    ncol = n
    nrow = n
    index = 0

    while nrow > 1
      # row print
      while ncol > 1

        if (index <= 9) || !is_valid_number(board[index])
          print "  #{board[index]} |"
        else
          print " #{board[index]} |" 
        end

        index += 1
        ncol -= 1
      end

      # end of line of numbers
      if (index <= 9)  || !is_valid_number(board[index])
        print "  #{board[index]}\n"
      else
        print " #{board[index]}\n"
      end
#      print " #{board[index]}\n"
      index += 1
      ncol = n
      
      while ncol > 1
        print "====+"
        ncol -= 1
      end
      
      # end of line of symbols
      print "====\n"
      ncol = n
      nrow -= 1
    end

    # prints last row
    while ncol > 1
      if (index <= 9) || !is_valid_number(board[index])
        print "  #{board[index]} |"
      else
        print " #{board[index]} |"
      end

      index += 1
      ncol -= 1
    end

    # last col
    if (index <= 9)  || !is_valid_number(board[index])
      print "  #{board[index]}\n"
    else
      print " #{board[index]}\n"
    end

  end
end
