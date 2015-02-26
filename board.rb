require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
# require_relative 'stepping_piece'
# require_relative 'sliding_piece'
# require_relative 'piece'
require 'byebug'


class Board
  attr_accessor :grid

  EDGE_ROW = [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]
  CHAR_HASH = {
    rook: 'r', knight: 'k', bishop: 'b',
    king: 'K', queen: 'Q', pawn: 'p'
  }

  def initialize
    @grid = Array.new(8) { Array.new(8) {nil} }
  end

  def place_pieces
    place_edge_rows
    place_pawns
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @grid[x][y]
  end

  def []=(pos, object)
    x, y = pos[0], pos[1]
    @grid[x][y] = object
  end


  def in_check?(color)
    #
  end

  def render
    render_string = ""
    render_string += "  a b c d e f g h\n".colorize(:red)
    @grid.each_index do |row|
      render_string += render_row(row)
    end
    render_string += "  a b c d e f g h\n".colorize(:red)
  end

  def occupied?(pos)
    !(self[pos].nil?)
  end

  def valid_position?(pos)
    x = pos[0]
    y = pos[1]

    return false if (x > 7 || x < 0) || (y > 7 || y < 0)

    true
  end

  def deep_dup
    duped_pieces = []

    duped_board = Board.new

    @grid.flatten.compact.each { |el| duped_pieces << el.dup(duped_board) }

    duped_pieces.each do |piece|
      duped_board[piece.position] = piece
    end

    duped_board
  end

  def move(start, finish)
    unless self.valid_position?(start)
      raise ArgumentError.new "No piece selected"
    end

    piece_choice = self[start]

    if piece_choice.moves.include?(finish)
      if self.occupied?(finish)
        self[finish].position = nil
      end
      self[finish] = piece_choice
      self[start] = nil
      piece_choice.position = finish
    else
      raise ArgumentError.new "Invalid Move"
    end
  end

  private

  def place_edge_rows
    pieces = []


    @grid[0].each_with_index do |tile, idx|
      pieces << EDGE_ROW[idx].new(self, :blue, [0, idx])
    end


    pieces.each do |piece|
      self[piece.position] = piece
    end

    pieces = []

    @grid[7].each_with_index do |tile, idx|
      pieces << EDGE_ROW[idx].new(self, :white, [7, idx])
    end

    pieces.each do |piece|
      self[piece.position] = piece
    end
  end

  def place_pawns
    pieces = []

    @grid[1].each_with_index do |tile, idx|
      pieces << Pawn.new(self, :blue, [1, idx])
    end

    pieces.each do |piece|
      self[piece.position] = piece
    end

    pieces = []

    @grid[6].each_with_index do |tile, idx|
      pieces << Pawn.new(self, :white, [6, idx])
    end

    pieces.each do |piece|
      self[piece.position] = piece
    end
  end

  def render_row(row)
    render_string = "#{8 - row} ".colorize(:red)
    @grid[row].each_index do |idx2|
      render_string << convert_to_character(row, idx2) + " "
    end
    render_string += "#{8 - row}\n".colorize(:red)
  end

  def convert_to_character(x, y)
    case self.occupied?([x, y])
    when true
      "#{CHAR_HASH[@grid[x][y].type]}".colorize(@grid[x][y].color)
    when false
      "_"
    end
  end

  def symbol_to_instance(symbol)
    eval(symbol.to_s.capitalize + ".new(self, nil, nil)")
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.place_pieces
  puts board.render
  board.move([1,0], [2, 0])
  puts board.render
  board.move([0,0], [1,0])
  puts board.render
end
