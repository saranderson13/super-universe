class Power < ApplicationRecord

  validates_presence_of :name

  has_many :character_powers
  has_many :characters, through: :character_powers

  has_many :power_moves
  has_many :moves, through: :power_moves


  # MOVE SETTER AND READER METHODS
  def add_move(move)
    # Determine the type of move trying to be added.
    mtype = move.move_type
    # Check to see if the power already has a move of that type.
    old_of_type = self.moves.select { |m| m.move_type == mtype }
    # If the move trying to be added == the old move of that type, just return the move.
    return move if old_of_type[0] == move
    # If there is already a move of that type that doesn't match the move being added, delete it.
    self.moves.delete(old_of_type[0]) if !old_of_type.empty?
    # Shovel in the new move.
    self.moves << move
  end

  def fetch_move(move_type)
    self.moves.find_by(move_type: move_type)
  end

end
