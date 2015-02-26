require_relative 'sliding_piece'

class King < SteppingPiece
  attr_reader :type

  def initialize(board, color, position)
    @type = :king
    super
  end

  def delta
    [
      [-1, -1], [-1, 1],
      [-1, 0], [0, -1],
      [0, 1], [1, -1],
      [1, 1], [1, 0]
    ]
  end

end
