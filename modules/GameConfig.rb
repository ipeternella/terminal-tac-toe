# ------------------------------------------------------------------------
# This module contains functions that are used to configure the game
# when its being started. The following properties are configured by
# the player's input:
#
# difficulty: newbie, medium or hard
#
# game_type:  player vs computer, player vs player, computer vs computer
# 
# p1_mark/p2_mark : sets a single char (string) to be the player mark
# (e.g., "X", "O", etc.)
#
# n: the number of rows/cols of the board
#
# board: builds a string array to be used as the board of the game
# ------------------------------------------------------------------------

module GameConfig

  def get_game_difficulty
    # This function keeps asking for a difficulty level (1,2 or 3) until
    # the player chooses one these options.
    #
    # @return difficulty is the difficulty level (int).
    
    puts "===== Choose difficulty level: ====="
    puts " 1 - Newbie :(\n 2 - Medium :)\n 3 - Hard >:)"

    difficulty = nil

    until difficulty
      # reads player input, trims and casts to int
      difficulty = gets.chomp.to_i

      if !difficulty.between?(1,3)
        difficulty = nil
      end
      
    end

    return difficulty
  end
 
  def get_game_type
    # This function keeps asking for a game type (1,2 or 3) until
    # the player chooses one these options.
    #
    # @return game_type is the the game_type (int).
    
    puts "===== Choose the game type: ====="
    puts " 1 - Player vs Computer\n 2 - Player vs Player\n 3 - Computer vs Computer"

    game_type = nil

    until game_type
      # reads player input, trims and casts to int
      game_type = gets.chomp.to_i

      if !game_type.between?(1,3)
        game_type = nil
      end
      
    end

    return game_type
  end

  def puts_welcome
    # This function prints a welcome message to the player.
    
    puts "*****************************************"
    puts "*         Terminal Tac Toe v1.0         *"
    puts "*           Welcome, player!            *"
    puts "*                                       *"
    puts "*               X | 1 | 2               *\n"
    puts "*              ===+===+===              *\n"
    puts "*               3 | X | 5               *\n"
    puts "*              ===+===+===              *\n"
    puts "*               6 | 7 | X               *\n"
    puts "*                                       *"
    puts "*                          by: I.G.P.   *"
    puts "*****************************************"
  end

  def get_game_markers
    # This function keeps asking for the players'marks until
    # a valid char is entered for both (cant be numbers or be repeated)
    #
    # @return a hash with the 2 marks as values.
    
    p1_mark = nil
    p2_mark = nil
    
    puts "===== Please set the player 1 mark (only letters) ====="

    until p1_mark
      p1_mark = gets.chomp.upcase

      if !is_valid_mark(p1_mark)
        puts "invalid mark, try again please:"
        p1_mark = nil
      end
      
    end

    puts "===== Please set the player 2 (PC or human) mark (only letters) ====="
    until p2_mark
      p2_mark = gets.chomp.upcase

      if !is_valid_mark(p2_mark) || p2_mark == p1_mark
        puts "invalid mark, try again please (must be different than player 1's mark):"
        p2_mark = nil
      end
      
    end

    return {:p1_mark => p1_mark, :p2_mark => p2_mark}
  end

  def is_valid_mark(s)
    # Helper function used to check if a string contains only letters and no digits.
    #
    # @return true if the string has only letters. Otherwise, returns false.
    
    return s[/[a-zA-Z]+/] == s && s.length == 1
  end

  def is_valid_number(s)
    # Helper function used to check if a string contains only digits and no letters.
    #
    # @return true if the string has only digits. Otherwise, returns false.
    
    return s[/[0-9]+/]  == s
  end
  
  def get_board_size
    # This function keeps asking for a board size (number of rows and cols)
    # until an int between 3 and 5 (inclusive) is entered. Boards bigger than
    # 5 WILL WORK but are definitely boring to play.
    #
    # @return n is the board size (int).

    puts "===== Please set the number of rows/cols of the board [3-5] ====="

    n = nil
    
    until n
      # reads n string from user input and trims
      n = gets.chomp

      # && is a short circuit operator so if the string
      # has an unvalid int, the n.to_i operation wont throw an error
      if is_valid_number(n) && n.to_i.between?(3,5)
        return n.to_i
      else
        n = nil
      end
    end
    
  end

  def get_board(n)
    # This function creates the string array to be used as the board
    # (main data structure) for the tic tac toe game.
    #
    # @argument n is the board size (number of rows/cols)
    #
    # @return board is a string array which holds all indexes for the players inputs.
    
    board = []
    
    (0 .. n ** 2 - 1).each do |i| 
      board << i.to_s
    end

    return board
  end
  
end
