require 'colorize'

class Piece
  attr_accessor :position, :color

  def initialize(board, color, position)
    @board = board
    @color = color
    @position = position
    @moved = false
  end

  def moves(position)

  end

  def possible_move?(location)

  end
end

class Pawn < Piece
  attr_reader :type

  DELTA = delta(color, moved)

  def initialize(board, color, position)
    @type = :pawn
    super
  end

  def delta(color, moved)
    unless moved
      self.color == :white ? [0, -1] : [0, 1]
    else
      self.color == :white ? [0, -2] : [0, 2]
    end
  end

  def moves(position)
    board = @board.deep_dup

    DELTA.map { |delta| check_possible_move(position, delta, board) }
  end

  def check_possible_move(pos, delta, board)
    pos = [pos[0] + delta[0], [pos[1] + delta[1]]

    if board[pos].color == self.color || !board.valid_position?(pos)
      pos = [pos[0] - delta[0], [pos[1] - delta[1]]
    else
      pos
    end
  end


end

class SteppingPiece < Piece

  DELTA = []

  def moves(position)
    board = @board.deep_dup

    DELTA.map { |delta| check_possible_move(position, delta, board) }
  end

  def check_possible_move(pos, delta, board)
    pos = [pos[0] + delta[0], [pos[1] + delta[1]]

    if board[pos].color == self.color || !board.valid_position?(pos)
      pos = [pos[0] - delta[0], [pos[1] - delta[1]]
    else
      pos
    end
  end
end

class King < SteppingPiece
  attr_reader :type

  DELTA = [
    [-1, -1], [-1, 1],
    [-1, 0], [0, -1],
    [0, 1], [1, -1],
    [1, 1], [1, 0]
  ]

  def initialize(board, color, position)
    @type = :king
    super
  end

end

class Knight < SteppingPiece
  attr_reader :type

  DELTA = [
    [-2, 1], [-2, -1],
    [2, 1],  [2, -1],
    [1, 2],  [-1, 2],
    [1, -2], [-1, -2]
  ]

  def initialize(board, color, position)
    @type = :knight
    super
  end
end

class SlidingPiece < Piece

  def check_possible_move(pos, delta, board)
    pos = [pos[0] + delta[0], [pos[1] + delta[1]]

    until board[pos].occupied? || !board.valid_position?(pos)
      pos = [pos[0] + delta[0], [pos[1] + delta[1]]
    end

    if board[pos].color == self.color || !board.valid_position?(pos)
      pos = [pos[0] - delta[0], [pos[1] - delta[1]]
    else
      pos
    end
  end

  def moves(position)
    board = @board.deep_dup

    DELTA.map { |delta| check_possible_move(position, delta, board) }
  end
end

class Rook < SlidingPiece
  attr_reader :type

  DELTA = [
  [1, 0], [-1, 0],
  [0, 1], [0, -1]
  ]

  def initialize(board, color, position)
    @type = :rook
    super
  end

  def moves(position)
    super
  end

  def check_possible_move(pos, delta, board)
    super
  end

end

class Bishop < SlidingPiece
  attr_reader :type

  DELTA = [
    [-1, -1], [-1, 1],
    [1 , -1], [1, 1 ]
  ]

  def initialize(board, color, position)
    @type = :bishop
    super
  end

  def moves(position)
    super
  end

  def check_possible_move(pos, delta, board)
    super
  end
end

class Queen < SlidingPiece
  attr_reader :type

  DELTA = [
    [1, 0],   [-1, 0],
    [0, 1],   [0, -1],
    [-1, -1], [-1, 1],
    [1 , -1], [1, 1 ]
  ]

  def initialize(board, color, position)
    @type = :queen
    super
  end

  def moves(position)
    super
  end

  def check_possible_move(pos, delta, board)
    super
  end
end


class Board
  attr_accessor :grid

  EDGE_ROW = [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]
  CHAR_HASH = {
    rook: 'r', knight: 'k', bishop: 'b',
    king: 'K', queen: 'Q', pawn: 'p'
  }

  def initialize
    @grid = Array.new(8){Array.new(8){nil}}

    place_pieces
  end

  def place_pieces
    place_edge_rows
    place_pawns
  end

  def []=(x, y)
    @grid[x][y]
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
    !(@grid[pos[0]][pos[1]].nil?)
  end

  private

  def place_edge_rows
    @grid[0] = @grid[0].each_with_index.map do |tile, idx|
      tile = EDGE_ROW[idx].new(self, :blue, [0, idx])

    end

    @grid[7] = @grid[7].each_with_index.map do |tile, idx|
      tile = EDGE_ROW[idx].new(self, :white, [7, idx])

    end
  end

  def place_pawns
    @grid[1] = @grid[1].each_with_index.map do |tile, idx|
      tile = Pawn.new(self, :blue, [1, idx])
    end

    @grid[6] = @grid[6].each_with_index.map do |tile, idx|
      tile = Pawn.new(self, :white, [6, idx])
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
