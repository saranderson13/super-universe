class Battle < ApplicationRecord

  # No validations because no direct user entry.
  # Data checked in controller before saves.

  belongs_to :protag, class_name: 'Character'
  belongs_to :antag, class_name: 'Character'

  def advance_turn
    self.turn_count += 1
  end

  def turn_dialog(attacking, move, defending, outcome)
    if outcome == "miss"
      msg = "Turn #{self.turn_count}:\n#{attacking.supername} does #{move.name}!\n#{defending.supername} #{move.fail_descrip}\nNo damage taken.\n\n" + self.log
      msg.html_safe
    elsif outcome == "hit"
      msg = "Turn #{self.turn_count}:\n#{attacking.supername} does #{move.name}!\n#{defending.supername} #{move.success_descrip}\n#{defending.supername} takes #{move.adjusted_pts(attacking, defending)} points of damage.\n\n" + self.log
      msg.html_safe
    end
  end

  def end_of_battle_dialog
    protag = Character.find_by(id: self.protag_id)
    antag = Character.find_by(id: self.antag_id)
    if outcome == "Victory"
      msg = "#{protag.supername} is victorious!\nThey have earned #{protag.win_points(antag)} points towards leveling up." + self.log
      if protag.lvl_progress >= protag.pts_to_next_lvl
        msg += "#{protag.supername} has reached level #{protag.level + 1}!\n\n"
      end
      msg.html_safe
    elsif outcome == "Defeat"
      msg = "#{protag.supername} was defeated!" + self.log
      msg.html_safe
    end
  end

end
