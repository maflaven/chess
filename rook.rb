require_relative 'sliding_piece'

class Rook < SlidingPiece
  attr_reader :type

  def initialize(board, color, position)
    @type = :rook
    super
  end

  def delta
    [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1]
    ]
  end
end
