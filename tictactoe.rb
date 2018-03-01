# coding: utf-8
=begin
[objetivo]: melhorar o codigo + adicionar novas features;
- Adicionar tratamento de entradas válidas;
- Permitir a seleção da modalidade de jogo: fácil, médio ou difícil (hoje está sempre no difícil);
- Permitir a seleção do tipo de jogo: computador vs computador, player vs player ou computador vs player;
=end

class Game

  attr_reader :n, :com_mark, :hum_mark, :board
  
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"] # contents = str, indexes = board
    @n = 3
    @com_mark = "X" # the computers marker
    @hum_mark = "O" # the users marker
    @difficulty = nil
  end

  def start_game
    # main function of the game: main loop
    @difficulty = get_game_difficulty
    
    # start by printing the board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    puts "Enter [0-8]:"

    # loop through until the game was won or tied
    until is_game_over(@board, @n) || tie(@board)

      # mutates the board
      get_human_spot
      
      if !is_game_over(@board, @n) && !tie(@board)
        eval_board
      end
      puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    end

    
    # # loop through until the game was won or tied
    # until game_is_over(@board) || tie(@board)
    #   get_human_spot
    #   if !game_is_over(@board) && !tie(@board)
    #     eval_board
    #   end
    #   puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    # end
    
    puts "Game over"
  end

  def get_game_difficulty
    # reads 
    difficulty = nil
    
    puts " Choose difficulty level:"
    puts " 1 - Newbie :(\n 2 - Medium :)\n 3 - Hard >:)"

    until difficulty
      difficulty = gets.chomp.to_i

      if !difficulty.between?(1,3)
        difficulty = nil
      end
      
    end

    return difficulty
  end

  def is_valid_spot(spot, board)
    # checks if input contains a valid int
    if !(Integer(spot) rescue false)
      return false
    else
      spot = spot.to_i
    end
    
    # validates min and max spots
    if spot.between?(0, @n ** 2 - 1)

      # validates when a board is already marked
      if board[spot] != @com_mark && board[spot] != @hum_mark
        return true
      else
        return false
      end
    else
      # outside acceptable range
      return false
    end
  end

  def get_human_spot
    # gets human spot and mutates the board
    
    spot = nil
    until spot
      # reads player input as string
      spot = gets.chomp

      # tests if the slot is empty on the board
      if is_valid_spot(spot, @board)
        # mutates the board
        @board[spot.to_i] = @hum_mark
      else
        spot = nil
      end
    end
  end

  def get_available_spaces(board)
    # reads board and return an array with empty spaces as strings
    available_spaces = []
    
    # traverses board array --> part
    board.each do |space|
      # if slot is available
      if space != @com_mark && space != @hum_mark
        # appends available spaces
        available_spaces << space
      end
    end

    return available_spaces
  end
  
  def eval_board
    spot = nil
    
    until spot
      spot = get_com_move(@board, @difficulty)
      @board[spot] = @com_mark

      as = get_available_spaces(@board)
      puts "AFTER PC MOVE: #{as}"

    end
  end

  def get_random_move(board, random_gen=nil)
    as = get_available_spaces(board)

    # checks for seed (used for testing)
    if !random_gen
      random_gen = Random.new
    end
    
    # random ix for as array
    random_ix = random_gen.rand(0 .. as.length - 1)
    move = as[random_ix].to_i
    
    return move
  end

  def get_move_to_win(board, player_mark)
    as = get_available_spaces(board)
    
    as.each do |as|
      # sets a mark on an available spot
      board[as.to_i] = player_mark
      
      # checks if the mark will finish the game, so pc must block it
      if is_game_over(board, @n)
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
  
  def get_com_move(board, difficulty, random_gen=nil)
    as = get_available_spaces(board)

    puts "BEFORE PC MOVE: #{as}"
      
    case difficulty
    when 1 # newbie
      return get_random_move(board)
      
    when 2 # medium
      # gets move to block the player
      move = get_move_to_win(board, @hum_mark)

      if move.nil?
        # no move is about to finish the game
        return get_random_move(board)
      else
        # player is about to win and pc must block it
        return move
      end
      
      return nil
    when 3 # hard
      # here, pc blocks player but also scans for plays to win
      
      # checks if pc can win with next move
      move = get_move_to_win(board, @com_mark)

      # pc cannot win, so checks if player is about to
      if move.nil?

        move = get_move_to_win(board, @hum_mark)

        if move.nil?
          # next player cannot win too
          return get_random_move(board)
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
  
  def horizontal_scan(board, n)
    row_values = []
    count = 0
    
    board.each do |s|      
      row_values << s
      count += 1

      # end of the row
      if count == n
        if row_values.uniq.length == 1
          return true
        else
          # reset for next row
          count = 0
          row_values = []
        end
      end
    end

    return false
  end

  def vertical_scan(board, n)
    col_values = []
    nrow = n
    i = 0
    j = 0

    # loops through columns
    while i < n
      j = i

      # loops through rows
      while nrow > 0
        col_values << board[j]        
        j += n
        nrow -= 1
      end
      
      if col_values.uniq.length == 1
        return true
      else
        col_values = []
        nrow = n
        i += 1
      end
    end

    return false
  end

  def diag_scan(board, n)
    diag_values = []
    count = 0
    
    board.each_with_index do |s, i|
      if i == count
        diag_values << s
        count += (n + 1)
      end      
    end

    if diag_values.uniq.length == 1
      return true
    end

    diag_values = []
    count = n - 1

    board.each_with_index do |s, i|
      if i == count
        diag_values << s
        count += (n - 1)
      end
    end

    # last value is always a non diagonal one, so drop it
    diag_values = diag_values[0...-1] 
    
    if diag_values.uniq.length == 1
      return true
    end

    # no diagonals found
    return false
  end
  
  def is_game_over(board, n)
    return vertical_scan(board, n) || horizontal_scan(board, n) || diag_scan(board, n)
  end
  
  def game_is_over(b)
    # # checks if uniq return only one marker which means someone has won
    # [b[0], b[1], b[2]].uniq.length == 1 ||
    # [b[3], b[4], b[5]].uniq.length == 1 ||
    # [b[6], b[7], b[8]].uniq.length == 1 ||
    # [b[0], b[3], b[6]].uniq.length == 1 ||
    # [b[1], b[4], b[7]].uniq.length == 1 ||
    # [b[2], b[5], b[8]].uniq.length == 1 ||
    # [b[0], b[4], b[8]].uniq.length == 1 ||
    # [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie(b)
    # checks if whole board array is filled
    b.all? { |s| s == "X" || s == "O" }
  end

end

TEST = false

if !TEST
  game = Game.new
  game.start_game
else
  # testing
end
