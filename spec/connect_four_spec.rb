require './lib/connect_four'
RSpec.describe HelperMethods do
  class TestClass
    include HelperMethods
  end
  
  describe TestClass do
    let(:instance){TestClass.new}
    describe '#coin_toss' do
      it 'returns either "heads" or "tails"' do
        expect(instance.coin_toss).to satisfy { |result| result == 'heads' || result == 'tails' }
      end
      
      it 'returns "heads" or "tails" with approximately equal probability' do
        results = []
        200.times do
          results << instance.coin_toss
        end
        num_heads = results.count('heads')
        num_tails = results.count('tails')
        expect(num_heads).to be_within(50).of(num_tails) # allow for up to 5% difference in distribution
      end
    end
  end
  end

describe Connect_four do
  describe '#initialize_board' do
    subject(:game){described_class.new()}
    it 'initializes the board correctly' do
      expected_board = Array.new(6) { Array.new(7, '') }
      result = game.initialize_board
      expect(result).to eq(expected_board)
    end
  end

  describe '#player_sign_determination' do
    subject(:game){described_class.new()}
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:sleep)
    end
    it 'assigns x to player who selects heads' do
      allow(game).to receive(:coin_toss).and_return('heads')
      result = game.player_sign_determination
      expect(result).to eq('heads')
    end
    it 'assigns o to player who selects tails' do
      allow(game).to receive(:coin_toss).and_return('tails')
      result = game.player_sign_determination
      expect(result).to eq('tails')
    end
  end

  describe '#display_board' do
    subject(:game){described_class.new()}
    it 'it displays the board correctly' do
      
      board = [["X", " ", " ", " ", " ", " ", " "],
               ["O", " ", " ", " ", " ", " ", " "],
               ["X", "O", " ", " ", " ", " ", " "],
               ["X", "X", "O", " ", " ", " ", " "],
               ["O", "O", "O", "X", " ", " ", " "],
               ["X", "X", "O", "X", " ", " ", " "]]
               expected = <<~BOARD.strip
               | X |   |   |   |   |   |   |
               | O |   |   |   |   |   |   |
               | X | O |   |   |   |   |   |
               | X | X | O |   |   |   |   |
               | O | O | O | X |   |   |   |
               | X | X | O | X |   |   |   |
                -----------------------------
                 0   1   2   3   4   5   6
               BOARD
                       
               
      result = game.display_board(board)
      expect(result).to eq(expected)
    end
  end

  describe '#column_choose' do
    subject(:game){described_class.new}
    it 'returns a number between 1-7' do
      player = 'x'
      allow(game).to receive(:gets).and_return('3')
      result = game.column_choose(player)
      expect(result).to eq(3)
    end
    it 'prints error message twice if wrong input twice' do
      player = 'x'
      allow(game).to receive(:puts).with("player with #{player} enter a number")
      allow(game).to receive(:gets).and_return('8','9','3')
      expect(game).to receive(:puts).with('wrong input, input another').twice
      game.column_choose(player)
    end
  end
  
  describe '#validate_input' do
    subject(:game) {described_class.new()}
    context 'when given a valid input and column isnt full' do
      before do
        allow(game).to receive(:board).and_return(Array.new(6){Array.new(7, '')})
      end
      it 'returns valid input' do
        input = 3
        game.board[0][input] = ''
        expect(game.validate_input(input)).to eq(3)
      end
    end
    context 'when given an invalid input as an argument but column isnt full' do
      it 'returns nil' do
        input = 7
        expect(game.validate_input(input)).to eq(nil)
      end
    end

    context 'when given a valid input but column is full' do
      it 'returns nil' do
        input = 2
        game.board[0][input] = 'x'
        expect(game.validate_input(input)).to eq(nil)
      end
    end
  end

  describe "#update_board" do
    subject(:game) {described_class.new()}
    context 'when a piece is placed in an empty board' do
      it 'it drops to the lowermost row' do
        player = 'x'
        board = Array.new(6){Array.new(7, '')}
        expected_board = [["", "", "", "", "", "", ""],
                          ["", "", "", "", "", "", ""],
                          ["", "", "", "", "", "", ""],
                          ["", "", "", "", "", "", ""],
                          ["", "", "", "", "", "", ""],
                          ["", "", "x", "", "", "", ""]]
      
       
        game.update_board(board, 2, player)
        
        expect(board).to eq(expected_board)
      end
    end
    context 'when a piece is placed in an column thats not empty' do
      it 'it fills the space above the filled position' do
        player = 'x'
        board = [["", "", "", "", "", "", ""],
                 ["", "", "", "", "", "", ""],
                 ["", "", "", "", "", "", ""],
                 ["", "", "", "", "", "", ""],
                 ["", "", "", "", "", "", ""],
                 ["", "", "x", "", "", "", ""]]
        expected_board = [["", "", "", "", "", "", ""],
                          ["", "", "", "", "", "", ""],
                          ["", "", "", "", "", "", ""],
                          ["", "", "", "", "", "", ""],
                          ["", "", "x", "", "", "", ""],
                          ["", "", "x", "", "", "", ""]]
        
        game.update_board(board, 2, player)
        
        expect(board).to eq(expected_board)
      end
    end
    context 'when the column is full' do
      it "the board doesn't get updated" do
        player = 'x'
        board = [["", "", "o", "", "", "", ""],
                 ["", "", "x", "", "", "", ""],
                 ["", "", "x", "", "", "", ""],
                 ["", "", "x", "", "", "", ""],
                 ["", "", "x", "", "", "", ""],
                 ["", "", "x", "", "", "", ""]]
        
        expected_board = [["", "", "o", "", "", "", ""],
                          ["", "", "x", "", "", "", ""],
                          ["", "", "x", "", "", "", ""],
                          ["", "", "x", "", "", "", ""],
                          ["", "", "x", "", "", "", ""],
                          ["", "", "x", "", "", "", ""]]
        game.update_board(board, 2, player)
        expect(board).to eq(expected_board)
      end
    end
  end

  describe '#check_for_win' do
    subject(:game) {described_class.new()}
    context 'when there are four vertical' do
      it 'returns there is a win' do
        player = 'x'
        board = [["", "", "", "", "", "", ""],
                 ["", "", "", "", "", "", ""],
                 ["", "", "x", "", "", "", ""],
                 ["", "", "x", "x", "x", "", "x"],
                 ["", "", "x", "", "", "", ""],
                 ["", "", "x", "", "", "", ""]] 
        result = game.check_for_win(board, player)
        expect(result).to eq(true)
      end
    end

    context 'when there is a four horizontal wins' do
      it 'returns a win' do
        player = 'x'
        board =  [["", "", "", "", "", "", ""],
                  ["", "", "", "", "", "", ""],
                  ["", "", "", "", "", "", ""],
                  ["", "", "", "x", "x", "x", "x"],
                  ["", "", "x", "", "", "", ""],
                  ["", "", "x", "", "", "", ""]] 
        result = game.check_for_win(board, player)
        expect(result).to eq(true)
      end
    end

    context 'when there are diagonal wins' do
      it 'returns a win' do
        player = 'x'
        board =  [["X", " ", " ", " ", " ", " ", " "],
                  ["O", " ", " ", " ", " ", " ", " "],
                  ["X", "O", " ", "x", " ", " ", " "],
                  ["X", "X", "x", " ", " ", " ", " "],
                  ["O", "x", "O", "X", " ", " ", " "],
                  ["x", "X", "O", "X", " ", " ", " "]]
        result = game.check_for_win(board, player)
        expect(result).to eq(true)
      end
    end
  end

  describe '#board_full?' do
    subject(:game){described_class.new()}
    it 'returns true if the board is full' do
      board = [["o", "x", "o", "x", "o", "o", "o"],
               ["x", "o", "x", "o", "x", "o", "x"],
               ["o", "x", "o", "x", "o", "x", "o"],
               ["x", "o", "x", "o", "x", "o", "x"],
               ["o", "x", "o", "x", "o", "x", "o"],
               ["x", "o", "x", "o", "x", "o", "x"]]
      result = game.board_full?(board)
      expect(result).to eq(true)
    end
  end
end
