require_relative 'stepping_piece'

class Knight < SteppingPiece
  attr_reader :type

  def initialize(board, color, position)
    @type = :knight
    super
  end

  def delta
    [[-1, 2], [1, 2],
      [2, 1], [2, -1],
      [1, -2], [-1, -2],
      [-2, -1],[-2, 1]
    ]
    self.color == :white ? :
  end

end
