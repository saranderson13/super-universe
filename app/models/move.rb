class Move < ApplicationRecord

  MOVE_TYPES = ["att", "def", "pwr"]

  validates_presence_of :name, :move_type, :base_pts, :success_descrip, :fail_descrip
  validates :move_type, inclusion: { in: MOVE_TYPES }

  has_many :power_moves
  has_many :powers, through: :power_moves

end
