board = Array.new(6) { Array.new(7, " ") }

def display_board(board)
  board.each do |row|
    puts row.join("|")
  end
end

def get_column_number
  puts "Enter a column number (1-7):"
  column = gets.chomp.to_i - 1
  # TODO: validate input and check if column is full
  return column
end

def update_board(board, column, player)
  row = board.length - 1
  while row >= 0
    if board[row][column] == " "
      board[row][column] = player
      return
    end
    row -= 1
  end
end

def check_for_win(board, player)
  # TODO: implement win checking logic
end

current_player = "X"

loop do
  display_board(board)
  column = get_column_number()
  update_board(board, column, current_player)
  if check_for_win(board, current_player)
    puts "#{current_player} wins!"
    break
  elsif board.flatten.none? { |cell| cell == " " }
    puts "Tie game!"
    break
  else
    current_player = (current_player == "X" ? "O" : "X")
  end
end
