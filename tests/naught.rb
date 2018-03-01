available_spaces = []
best_move = nil

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

  # returns pc move that finishes the game
  if game_is_over(board)
    best_move = as.to_i
    # restores board to available space
    board[as.to_i] = as
    return best_move
  else
    board[as.to_i] = @hum_mark

    # checks if human is about to finish game and blocks it
    if game_is_over(board)
      best_move = as.to_i
      board[as.to_i] = as
      return best_move
    else
      board[as.to_i] = as
    end
  end
end

# if pc cant finish ame and human is not about to finish it
if best_move
  return best_move
else
  # returns random pc move
  n = rand(0..available_spaces.count)
  return available_spaces[no].to_i
end
