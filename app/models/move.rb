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
    when "def"
      "Defensive Tactic"
    end
  end

  def adjusted_pts(protag, antag)
    if self.move_type == "att"
      (((self.base_pts + (2 * protag.level)) * protag.protag_att_adjustment) * antag.antag_def_adjustment).round
    elsif self.move_type == "pwr"
      (((self.base_pts + (4 * protag.level)) * protag.protag_att_adjustment) * antag.antag_def_adjustment).round
    end
  end

end
