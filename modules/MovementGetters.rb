# ------------------------------------------------------------------------
# This module contains functions to read human input and to compute
# the computer moves which can be a random computer move or a move
# based on a strategy (such as blocking the other player to prevent
# his victory). Furthermore, the computer moves varies according to
# the difficulty level.
# ------------------------------------------------------------------------

module MovementGetters

  def get_com_move(board, n, difficulty, random_gen=nil, player_mark, adversary_mark)
    # This function computes the computer move based on the game difficulty. On the
    # newbie level, it generates random moves only. On the medium level, it generates
    # random moves only but blocks the other player to prevent his victory. Finally,
    # on the hard mode, it generates random moves but blocks the player and searches
    # for possible moves to win the game.
    #
    # @argument board is a reference to the string array (board).
    # @argument n is the board size (number of rows/cols).
    # @argument difficulty is the difficulty level (newbie, medium or hard).
    # @argument random_gen is random number generator which is used only for testing purposes.
    # @argument player_mark is a string (single char) used as the computer mark on the board
    # @argument adversary_mark is a string (single char) used as the computer's adversary 
    # mark on the board (human or other pc)
    #
    # @return move is the computer move (int).

    # gets all empty spots on the board
    as = get_available_spaces(board, player_mark, adversary_mark)

    # message to indicate whose turn it is
    puts "COMPUTER IS PLAYING..."
        
    case difficulty
    when 1 # newbie
      # generates random moves ONLY
      return get_random_move(board, random_gen, player_mark, adversary_mark)
      
    when 2 # medium
      # checks if the computer adversary is about to win and returns
      # a move to block and prevent his victory
      move = get_move_to_win(board, n, adversary_mark, player_mark)

      if move.nil?
        # if the computer's adversary is not about to win, it returns a random move
        return get_random_move(board, random_gen, player_mark, adversary_mark)
      else
        # returns blocking move
        return move
      end
      
      return nil
    when 3 # hard
      # here, pc blocks player but also scans for plays to win
      
      # checks if the computer can win with any next move (scans the board)
      move = get_move_to_win(board, n, player_mark, adversary_mark)

      if move.nil?
        # since the computer CANNOT win wih any next next move, checks if the
        # computer adversary is about to win and returns a move to block him
        move = get_move_to_win(board, n, adversary_mark, player_mark)

        if move.nil?
          # if the computer's adversary is not about to win, it returns a random move
          return get_random_move(board, random_gen, player_mark, adversary_mark)
        else
          # returns move to block the computer's adversary
          return move
        end
        
      else
        # returns move for the computer to win
        return move
      end
      
    end
  end
    
  def get_human_move(board, n, p1_mark, p2_mark)
    # This function keeps asking for the human next move until a valid spot
    # is given (cannot be out of the board or a spot that already has another player's mark)
    #
    # @argument n is the board size (number of rows/cols)
    # @argument p1_mark is a string (single char) used as player 1's mark on the board (human)
    # @argument p2_mark is a string (single char) used as player 2's mark on the board (other human or pc)
    #
    # @return move is the human move (int).

    # messages to indicate whose turn it is
    puts "YOUR TURN, HUMAN..."
    
    move = nil
    
    until move
      # reads player input as string and trims it
      move = gets.chomp
      
      # tests if the slot is a valid one (empty and within the board)
      if is_valid_spot(move, board, n, p1_mark, p2_mark)
        # returns int as the move
        return move.to_i 
      else
        # wrong input
        move = nil
        puts "Invalid spot (not empty or out of the board), please try again:"
      end
    end
  end

  def get_random_move(board, random_gen=nil, p1_mark, p2_mark)
    # This function generates a random move for the computer.
    #
    # @argument board is a reference to the string array (board).
    # @argument random_gen is random number generator which is used only for testing purposes.
    # @argument p1_mark is a string (single char) used as player 1's mark on the board (human)
    # @argument p2_mark is a string (single char) used as player 2's mark on the board (other human or pc)
    #
    # @return move is the random computer move (int).

    # gets all empty spots on the board
    as = get_available_spaces(board, p1_mark, p2_mark)

    # checks if a random_gen was given for testing
    # if not, creates a new instance
    if !random_gen
      random_gen = Random.new
    end
    
    # random ix to pick a random space in the available spaces array 
    random_ix = random_gen.rand(0 .. as.length - 1)
    move = as[random_ix].to_i

    # returns random move (int)
    return move
  end

  def get_move_to_win(board, n, player_mark, adversary_mark)
    # This function generates, if possible, the computer's next move to win.
    #
    # @argument board is a reference to the string array (board).
    # @argument n is the board size (number of rows/cols).
    # @argument player_mark is a string (single char) used as the computer mark on the board.
    # @argument adversary_mark is a string (single char) used as the computer's adversary.
    #
    # @return move for the computer the win or nil if not possible.

    # gets all empty spots on the board
    as = get_available_spaces(board, player_mark, adversary_mark)

    # tries setting a computer mark on every to see if the computer can win
    as.each do |as|      
      # sets the computer mark on an available spot
      board[as.to_i] = player_mark
      
      # checks if the computer mark will finish the game
      if is_game_over(board, n, player_mark, adversary_mark)
        move = as.to_i
        
        # mutates board back to its original state
        board[as.to_i] = as

        # returns the computer move to win
        return move
      end

      # mutates board back to its original state
      board[as.to_i] = as
    end

    # if no computer move can win the game
    return nil
  end

  def get_available_spaces(board, p1_mark, p2_mark)
    # This function returns all empty spaces (without marks on the board).
    #
    # @argument board is a reference to the string array (board).
    # @argument p1_mark is a string (single char) used as player 1's mark on the board (human)
    # @argument p2_mark is a string (single char) used as player 2's mark on the board (other human or pc)
    #
    # @return available_spaces is a string array which contains only the indexes of spots that have no mark.
    
    available_spaces = []
    
    board.each do |space|
      # if slot is available (no player marks)
      if space != p1_mark && space != p2_mark
        # appends available spaces
        available_spaces << space
      end
    end
    
    return available_spaces
  end

  def is_valid_spot(spot, board, n, p1_mark, p2_mark)
    # This function returns true if a spot string is a valid integer, within the board indexes and
    # that it has not been occupied by a player mark.
    #
    # @argument spot a string which represents an index o the board.
    # @argument board is a reference to the string array (board).
    # @argument n is the board size (number of rows/cols).
    # @argument p1_mark is a string (single char) used as player 1's mark on the board (human).
    # @argument p2_mark is a string (single char) used as player 2's mark on the board (other human or pc).
    #
    # @return true if the spot is a valiad one. Otherwise, returns false.
    
    # checks if the string contains a valid integer (throws and rescues exception)
    if !(Integer(spot) rescue false)
      return false
    else
      # if valid, casts to int
      spot = spot.to_i
    end
    
    # checks if the spot is within the board
    if spot.between?(0, n ** 2 - 1)
      # checks if the spot has not been occupied by a player mark
      if board[spot] != p1_mark && board[spot] != p2_mark
        return true
      else
        # spot contains a player mark
        return false
      end
    else      
      # outside the board
      return false
    end
  end
  
end
