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
    if (index <= 9) || !is_valid_number(board[index])
      print "  #{board[index]}\n"
    else
      print " #{board[index]}\n"
    end

  end
