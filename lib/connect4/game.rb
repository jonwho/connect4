module Connect4
  class Game
    attr_accessor :p1, :p2, :board, :row_length, :col_length

    def initialize(p1, p2)
      @p1 = p1
      @p2 = p2
      # interesting that Array.new(6, Array.new(7)) will create a multi dimensional array
      # but each array in the rows are actually the same object
      # so setting @board[0][0] = :something will actually affect the entire column
      # not the specific indices
      # must use the syntax below to create a multi dimensional array where each row
      # are different objects
      @board = Array.new(6) { Array.new(7, ' ') }
      @row_length = 6
      @col_length = 7
      puts 'A new game is starting'
      keep_playing
    end

    def over?
      return false unless p1.won? || p2.won?

      winner = p1.won? ? p1 : p2
      puts "#{winner.color} has won!"
      true
    end

    # helps declare no winner
    def board_full?
      board.each do |row|
        return false if row.any? { |v| v == ' ' }
      end
      true
    end

    def keep_playing
      play(p1)
      play(p2)
      keep_playing
    end

    def play(player)
      puts "#{player.color}'s turn"
      puts 'choose a column (0 - 6)'
      pretty_print_board
      puts
      col = gets.chomp.to_i

      # ask player to play until valid move or game is over
      if put_piece(col, player)
        exit! if over?
      else
        play(player)
      end
    end

    # player should only choose the column they want to drop a piece
    # the piece is "dropped" into the column; moving into the column
    # until it reachs next available position bounded by row len
    def put_piece(col, player)
      # keep checking down the column until there's an available spot
      row = 0
      prev_row = row
      while row < row_length && board[row][col] == ' '
        prev_row = row
        row += 1
      end

      # check if prev_row has been filled, if not put piece down
      if board[prev_row][col] == ' '
        board[prev_row][col] = player.color
        check_win(prev_row, col, player)
        true
      else
        puts 'no more available space in this column!'
        false
      end
    end

    def check_win(row, col, player)
      # check row
      if check_row(row, col, player)
        player.won = true
      end

      # check column
      if check_column(row, col, player)
        player.won = true
      end

      # check diagonal left
      if (check_diagonal(row, col, player))
        player.won = true
      end
    end

    def check_row(row, col, player)
      count = 0
      move = 1

      while (col + move) < col_length && board[row][col + move] == player.color
        count += 1
        move += 1
      end

      move = 1
      while (col - move) >= 0 && board[row][col - move] == player.color
        count += 1
        move += 1
      end

      if count >= 3
        true
      else
        false
      end
    end

    def check_column(row, col, player)
      count = 0
      move = 1

      while (row + move) < row_length && board[row + move][col] == player.color
        count += 1
        move += 1
      end

      move = 1
      while (row - move) >= 0 && board[row - move][col] == player.color
        count += 1
        move += 1
      end

      if count >= 3
        true
      else
        false
      end
    end

    def check_diagonal(row, col, player)
      # just need 3 more matching to win
      count = 0
      move = 1

      # check left to right diagonal first
      # first go up and right
      while (row + move) < row_length && (col + move) < col_length &&
        !board[row + move][col + move].nil? &&
        board[row + move][col + move] == player.color

        count += 1
        move += 1
      end

      # now go down and left
      # reset vars to search down
      move = -1
      while (row + move) >= 0 && (col + move) >= 0 &&
        !board[row + move][col + move].nil? &&
        board[row + move][col + move] == player.color

        count += 1
        move -= 1
      end

      return true if count >= 3

      # reset vars for other diagonal
      count = 0
      move = 1
      # now check right to left diagonal
      # first go up and left
      while (row + move) < row_length && (col - move) >= 0 &&
        !board[row + move][col - move].nil? &&
        board[row + move][col - move] == player.color

        count += 1
        move += 1
      end

      # now go down and right
      # reset vars to search down
      while (row - move) >= 0 && (col + move) < col_length &&
        !board[row - move][col + move].nil? &&
        board[row - move][col + move] == player.color

        count += 1
        move += 1
      end

      if count >= 3
        true
      else
        false
      end
    end

    def pretty_print_board
      puts (0..6).to_a.join('|')

      board.each do |row|
        puts row.join('|')
      end
    end
  end
end
