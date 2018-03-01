# coding: utf-8
=begin
[objetivo]: melhorar o codigo + adicionar novas features;
- Adicionar tratamento de entradas válidas;
- Permitir a seleção da modalidade de jogo: fácil, médio ou difícil (hoje está sempre no difícil);
- Permitir a seleção do tipo de jogo: computador vs computador, player vs player ou computador vs player;
=end

class Game

  attr_reader :size, :com_mark, :hum_mark, :board
  
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"] # contents = str, indexes = board
    @size = 3
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
    until is_game_over(@board, @size) || tie(@board)

      get_human_spot
      if !is_game_over(@board, @size) && !tie(@board)
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
    if spot.between?(0, @size ** 2 - 1)

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
    # gets human spot
    
    spot = nil
    until spot
      # reads player input as string
      spot = gets.chomp

      # tests if the slot is empty on the board
      if is_valid_spot(spot, @board)
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
      
      if @board[4] == "4" # if 4 is empty, computer makes its move there
        spot = 4
        @board[spot] = @com_mark
      else # if 4 is not empty
        spot = get_best_move(@board, @com_mark) # gets int with index
        if @board[spot] != "X" && @board[spot] != "O" 
          # sets best move for pc
          @board[spot] = @com_mark
        else
          spot = nil
        end
      end
      
    end
  end

  def get_com_move(board, difficulty, random_gen=nil)
    as = get_available_spaces(board)

    # checks for seed (used for testing)
    if !random_gen
      random_gen = Random.new
    end
      
    case difficulty
    when 1 # newbie
      # here, PC makes random moves only            
      move = random_gen.rand(as.first.to_i .. as.last.to_i)

      return move
    when 2 # medium
      # PC makes random movies but blocks if user is about to win

      
      return nil
    when 3 # hard
      return nil
    end
  end
  
  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = [] # available spaces on board
    best_move = nil       # best move

    # traverses board array --> part
    board.each do |s|
      # if slot is available
      if s != "X" && s != "O"
        # appends available spaces
        available_spaces << s
      end
    end

    # traverses available spaces to set computer mark
    available_spaces.each do |as|
      # sets computer move
      board[as.to_i] = @com_mark

      # returns move that finishes the game
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum_mark
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = as
        end
      end
    end
    if best_move
      return best_move
    else
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
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
