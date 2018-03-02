# ------------------------------------------------------------------------
# This module contains functions to scan the board to determine
# whether a match is over or not. It contains vertical, horizontal
# diagonal and tie scans.
# ------------------------------------------------------------------------

module BoardScans  

  def tie(board, p1_mark, p2_mark)
    # This function scans the board values for ties, i.e., the whole string array is filled
    # but without any vertical, horizontal or diagonal wins.
    #
    # Example (3x3 board):
    #
    #            X | O | X 
    #           ===+===+===
    #            X | O | O               
    #           ===+===+===
    #            O | X | X 
    # 
    # @argument board is a reference to the string array (board).
    # @argument p1_mark is a string (single char) used as player 1's mark on the board
    # @argument p2_mark is a string (single char) used as player 2's mark on the board
    #
    # @return true for ties and, otherwise, false.
    
    # checks if whole board array is filled with players marks
    return board.all? { |s| s == p1_mark || s == p2_mark }
  end

  def horizontal_scan(board, n)
    # This function scans the board values to see if a player has won
    # horizontally.
    #
    # Example (3x3 board):
    #
    #            X | X | X 
    #           ===+===+===
    #            - | - | -               
    #           ===+===+===
    #            - | - | - 
    #
    # @argument board is a reference to the string array (board).
    # @argument n is the board size (number of rows/cols).
    #
    # @return true if a player has won horizontally. Otherwise, returns false.
        
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
    # This function scans the board values to see if a player has won
    # vertically.
    #
    # Example (3x3 board):
    #
    #            - | X | - 
    #           ===+===+===
    #            - | X | -               
    #           ===+===+===
    #            - | X | - 
    #
    # @argument board is a reference to the string array (board).
    # @argument n is the board size (number of rows/cols).
    #
    # @return true if a player has won vertically. Otherwise, returns false.
    
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
    # This function scans the board values to see if a player has won
    # diagonally.
    #
    # Example (3x3 board):
    #
    #            - | - | X 
    #           ===+===+===
    #            - | X | -               
    #           ===+===+===
    #            X | - | - 
    #
    # @argument board is a reference to the string array (board).
    # @argument n is the board size (number of rows/cols).
    #
    # @return true if a player has won diagonally. Otherwise, returns false.
        
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
  
end
