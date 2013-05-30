class Cell
  attr_accessor :value
  attr_reader :row, :column
 
  def initialize(position, value, board_size)
    @position = position
    @value = value
    @board_size = board_size
    
    @row = @position / @board_size
    @column = @position % @board_size
  end
end
 
class Player
  attr_reader :symbol
 
  def initialize(symbol)
    @symbol = symbol
  end
end
 
class Gameboard
  def initialize
    puts "Welcome to Tic-Tac-Toe!"
    print "What size board?: "
    @size = gets.chomp.to_i
    @board = Array.new(@size**2)
 
    @board.each_index do |i|
      @board[i] = Cell.new(i, i + 1, @size)
    end
 
    @turn = 0
    @players = [Player.new("O"), Player.new("X")]
  end
 
  def rows
    rows = []
    row_index = 0
 
    @size.times do
      rows << @board[row_index * 3, @size].map { |i| i.value }
      row_index += 1
    end
    rows
  end
 
  def columns
    columns = []
    @size.times { columns << [] }
 
    @board.each_index do |i|
      columns[i % @size] << @board[i].value
    end
    columns
  end
 
  def diagonals
    diagonals = [[], []]
 
    cell = 0
    @size.times do |i|
      diagonals[0] << @board[cell].value
      cell += (@size + 1)
    end
      
    cell = @size - 1
    @size.times do |i|
      diagonals[1] << @board[cell].value
      cell += (@size - 1)
    end
    diagonals
  end
 
  def win?
    lines = rows + columns + diagonals
    lines.each do |l|
      return true if l[0] != nil && l.uniq.length == 1
    end
    false
  end
 
  def cats_game?
    @turn == @size**2 && !win?
  end
 
  def print_board
    system('clear')
    puts "Board:"
    @board.each_index do |i|
      print "%2s " % @board[i].value.to_s
      if i % @size == (@size - 1)
        puts
        if i < (@size**2 - @size)
          print '-' * (@size * 4 - 1)
          puts
        end
      else
        print "|"
      end
    end
    puts
  end
 
  def player_move
    print "Player #{current_player.symbol}: Where would you like to move? "
    space = gets.chomp.to_i
    if @board[space - 1].value.is_a? Integer
      @board[space - 1].value = current_player.symbol
    else
      puts "Try again"
      player_move
    end
  end
 
  def current_player
    @players[@turn % 2]
  end
 
  def play
    print_board
    until win? || cats_game?
      @turn += 1
      player_move
      print_board
    end
 
    if win?
      puts "The winner is #{current_player.symbol}!"
    elsif cats_game?
      puts "Cat's Game!"
    end
  end
end
 
system('clear')
g = Gameboard.new
g.play
