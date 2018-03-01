module GameConfig

  def get_game_difficulty
    # reads 
    difficulty = nil
    
    puts "===== Choose difficulty level: ====="
    puts " 1 - Newbie :(\n 2 - Medium :)\n 3 - Hard >:)"

    until difficulty
      difficulty = gets.chomp.to_i

      if !difficulty.between?(1,3)
        difficulty = nil
      end
      
    end

    return difficulty
  end
 
  def get_game_type
    # reads 
    game_type = nil

    puts "===== Choose the game type level: ====="
    puts " 1 - Player vs Computer\n 2 - Player vs Player\n 3 - Computer vs Computer"

    until game_type
      game_type = gets.chomp.to_i

      if !game_type.between?(1,3)
        game_type = nil
      end
      
    end

    return game_type
  end

  def puts_welcome
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
    return s[/[a-zA-Z]+/] == s && s.length == 1
  end

  def is_valid_number(s)
    return s[/[0-9]+/]  == s
  end
  
  def get_board_size
    n = nil

    puts "===== Please set the board size (3 - 5 rows/cols!) ====="
    
    until n
      n = gets.chomp

      if is_valid_number(n) && n.to_i.between?(3,5)
        return n.to_i
      else
        n = nil
      end
    end
    
  end

  def get_board(n)
    board = []
    
    (0 .. n * n).each do |i| 
      board << i.to_s
    end

    return board
  end
  
end
