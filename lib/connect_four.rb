

class Connect_four
  attr_accessor :board

  def initialize
    @board = initialize_board
  end

  def initialize_board
    Array.new(6) { Array.new(7, '') }
  end

  def display_board(board)
    board_display_array = []
    board.each do |row|
      board_display_array.push(row.join('|'))
    end
    puts board_display_array
    board_display_array
  end

  def column_choose
    loop do
      puts 'enter a number'
      number_chosen = gets.chomp.to_i
      validated_input = validate_input(number_chosen)
      return validated_input unless validated_input.nil?

      puts 'wrong input, input another'
    end
  end

  def validate_input(input)
    return input if input >= 0 && input <= 6 && board[0][input] == ''
  end

  def update_board(board, column, player)
    row = board.length - 1

    while row >= 0
      if board[row][column] == ''
        board[row][column] = player
        return
      end
      row -= 1
    end
  end

  def check_for_win(board, player)
    check_horizontal_win(board, player) || check_vertical_win(board, player) || check_diagonal_win(board, player)
  end

  def check_vertical_win(board, player)
    7.times do |col|
      3.times do |row|
        if board[row][col] == player && board[row + 1][col] == player && board[row + 2][col] == player && board[row + 3][col] == player
          return true
        end
      end
    end
    false
  end

  def check_horizontal_win(board, player)
    6.times do |row|
      4.times do |col|
        if board[row][col] == player && board[row][col + 1] == player && board[row][col + 2] == player && board[row][col + 3] == player
          return true
        end
      end
    end
    false
  end

  def check_diagonal_win(board, player)
    (0..2).each do |row|
      (0..3).each do |col|
        if board[row][col] == player &&
           board[row+1][col+1] == player &&
           board[row+2][col+2] == player &&
           board[row+3][col+3] == player
          return true
        end
      end
    end
  
    # Check for diagonal win from top left to bottom right
    (3..5).each do |row|
      (0..3).each do |col|
        if board[row][col] == player &&
           board[row-1][col+1] == player &&
           board[row-2][col+2] == player &&
           board[row-3][col+3] == player
          return true
        end
      end
    end
  
    # No diagonal win found
    return false
  end

  def board_full?(board)
    board.each do |row|
      row.each do |cell|
        return false if cell == ''
      end
    end
    true
  end

  def game_play
    current_player = 'x'
    loop do
      display_board(board)
      column = column_choose
      update_board(board, column, current_player)
      if check_for_win(board, current_player)
        puts "#{current_player} wins!"
        break
      elsif board_full?(board)
        puts 'Tie game!'
        break
      else
        current_player = (current_player == 'x' ? 'o' : 'x')
      end
    end
  end
end

driver code

game = Connect_four.new
game.game_play
