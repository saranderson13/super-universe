class Move < ApplicationRecord

  MOVE_TYPES = ["att", "def", "pwr"]

  validates_presence_of :name, :move_type, :base_pts, :success_descrip, :fail_descrip
  validates :move_type, inclusion: { in: MOVE_TYPES }

  has_many :power_moves
  has_many :powers, through: :power_moves

  def long_type
    case self.move_type
    when "att"
      "Regular Attack"
    when "pwr"
      "Power Attack"
    end
  end

  def adjusted_pts(protag, antag)
    # The method is called with arguments of the attacker and their opponent in that order.

    # The type of move is determined - whether it is a common attack or a power attack.
    if self.move_type == "att"

      # The base points of the move are added to 2x the character's level:
      # That is then multiplied by a formula that takes the protagonist's attack stat into account.
      # The result of the #protag_att_adjustment method will be between 1 and 2, and increase the inflicted damage.
      # That result is then multiplied by a formula that takes the opposing character's defense stat into account.
      # The result of the #antag_def_adjustment method will be between 0 and 1, and will decrease the inflicted damage.
      (((self.base_pts + (2 * protag.level)) * protag.protag_att_adjustment) * (1 - antag.antag_def_adjustment)).round

      # If the move is a power move, there is a higher multiplier on the level.
      # Meaning power moves get stronger more quickly as you level up.
      # The formulas are otherwise the same.
    elsif self.move_type == "pwr"
      (((self.base_pts + (3 * protag.level)) * protag.protag_att_adjustment) * (1 - antag.antag_def_adjustment)).round
    end
  end

end
