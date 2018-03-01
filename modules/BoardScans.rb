module BoardScans

  def tie(board, p1_mark, p2_mark)
    # checks if whole board array is filled
    board.all? { |s| s == p1_mark || s == p2_mark }
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
  
end
