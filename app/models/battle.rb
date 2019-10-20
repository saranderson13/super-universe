class Battle < ApplicationRecord

  # No validations because no direct user entry.
  # Data checked in controller before saves.

  belongs_to :protag, class_name: 'Character'
  belongs_to :antag, class_name: 'Character'

  def advance_turn
    self.turn_count += 1
  end

end
