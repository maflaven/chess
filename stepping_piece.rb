require_relative 'piece'

class SteppingPiece < Piece

  def moves
    board = @board.deep_dup

    possible_moves = []

    delta.each do |delta|
      possible_moves << check_possible_move(@position, delta, board)
    end

    possible_moves.compact
  end

  def check_possible_move(pos, delta, board)
    pos_x = pos[0] + delta[0]
    pos_y = pos[1] + delta[1]

    if board.valid_position?([pos_x, pos_y])
      if board[[pos_x, pos_y]].nil? || board[[pos_x, pos_y]].color != self.color
        [pos_x, pos_y]
      end
    end
  end

  def delta
  end
end
