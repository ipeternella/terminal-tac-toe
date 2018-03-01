module MovementGetters

  def get_com_move(board, difficulty, random_gen=nil, player_mark, adversary_mark)
    as = get_available_spaces(board, player_mark, adversary_mark)

    puts "BEFORE PC MOVE: #{as}"
    
    case difficulty
    when 1 # newbie
      return get_random_move(board, player_mark, adversary_mark)
      
    when 2 # medium
      # gets move to block the player
      move = get_move_to_win(board, adversary_mark, player_mark)

      if move.nil?
        # no move is about to finish the game
        return get_random_move(board, player_mark, adversary_mark)
      else
        # player is about to win and pc must block it
        return move
      end
      
      return nil
    when 3 # hard
      # here, pc blocks player but also scans for plays to win
      
      # checks if pc can win with next move
      move = get_move_to_win(board, player_mark, adversary_mark)

      # pc cannot win, so checks if player is about to
      if move.nil?

        move = get_move_to_win(board, adversary_mark, player_mark)

        if move.nil?
          # next player cannot win too
          return get_random_move(board, player_mark, adversary_mark)
        else
          # returns move to block human
          return move
        end
        
      else
        # returns move for the pc to win
        return move
      end
      
    end
  end
    
  def get_human_move(board, p1_mark, p2_mark)
    # gets human spot and mutates the board
    
    move = nil
    until move
      # reads player input as string
      move = gets.chomp
      
      # tests if the slot is empty on the board
      if is_valid_spot(move, board, p1_mark, p2_mark)
        # returns AS INTEGER
        return move.to_i        
      else
        move = nil
      end
    end
  end

  def get_random_move(board, random_gen=nil, p1_mark, p2_mark)
    as = get_available_spaces(board, p1_mark, p2_mark)

    # checks for seed (used for testing)
    if !random_gen
      random_gen = Random.new
    end
    
    # random ix for as array
    random_ix = random_gen.rand(0 .. as.length - 1)
    move = as[random_ix].to_i

    # returns int move
    return move
  end

  def get_move_to_win(board, player_mark, adversary_mark)
    as = get_available_spaces(board, player_mark, adversary_mark)
    
    as.each do |as|
      # sets a mark on an available spot
      board[as.to_i] = player_mark
      
      # checks if the mark will finish the game, so pc must block it
      if is_game_over(board, @n, player_mark, adversary_mark)
        move = as.to_i
        
        # mutates board back to its original state
        board[as.to_i] = as
        
        return move
      end

      # mutates board back to its original state
      board[as.to_i] = as
    end

    # if no move is about to finish the game
    return nil
  end

  def get_available_spaces(board, p1_mark, p2_mark)
    # reads board and return an array with empty spaces as strings
    available_spaces = []
    
    # traverses board array --> part
    board.each do |space|
      # if slot is available
      if space != p1_mark && space != p2_mark
        # appends available spaces
        available_spaces << space
      end
    end
    
    return available_spaces
  end

  def is_valid_spot(spot, board, p1_mark, p2_mark)
    # checks if input contains a valid int
    if !(Integer(spot) rescue false)
      return false
    else
      spot = spot.to_i
    end
    
    # validates min and max spots
    if spot.between?(0, @n ** 2 - 1)

      # validates when a board is already marked
      if board[spot] != p1_mark && board[spot] != p2_mark
        return true
      else
        return false
      end
    else
      # outside acceptable range
      return false
    end
  end
  
end
