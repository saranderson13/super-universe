class Power < ApplicationRecord

  POWER_TYPES = ["Physical Enhancement", "Mental Enhancement", "Elemental Mastery", "Magical Ability"]

  validates_presence_of :name
  validates_inclusion_of :pwr_type, in: POWER_TYPES

  has_many :character_powers
  has_many :characters, through: :character_powers

  has_many :power_moves
  has_many :moves, through: :power_moves
  accepts_nested_attributes_for :moves

  scope :physical_enhancements,  -> { where(pwr_type: "Physical Enhancement") }
  scope :mental_enhancements,  -> { where(pwr_type: "Mental Enhancement") }
  scope :elemental_masteries,  -> { where(pwr_type: "Elemental Mastery") }
  scope :magical_abilities,  -> { where(pwr_type: "Magical Ability") }


  # TO GRAB POWER TYPES IN CONTROLLER FOR NEW/EDIT POWER FORM
  def self.types
    POWER_TYPES
  end

  # TO AVOID MOVE DUPLICATION IN NEW/EDIT POWER FORM
  def replace_old_moves
    self.moves[1].destroy
    self.moves[0].destroy
  end


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
