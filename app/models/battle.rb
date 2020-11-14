class Battle < ApplicationRecord

  # No validations because no direct user entry.
  # Data checked in controller before saves.

  belongs_to :protag, class_name: 'Character'
  belongs_to :antag, class_name: 'Character'

  scope :in_progress, -> { where(outcome: "Pending") }
  scope :not_in_progress, -> { where('outcome != "Pending"') }
  scope :recent_battles, -> { where('outcome != "Pending"').order("updated_at desc").limit(50) }

  # def self.recent_battles
  #   self.where('outcome != "Pending"').order("updated_at desc").limit(5)
  # end

  def advance_turn
    self.turn_count += 1
  end

  def turn_dialog(attacking, move, defending, outcome)
    if outcome == "miss"
      msg = "[T#{self.turn_count}]: #{attacking.supername} uses #{move.name}!\n#{defending.supername} #{move.fail_descrip}\nNo damage taken.\n\n" + self.log
    elsif outcome == "hit"
      msg = "[T#{self.turn_count}]: #{attacking.supername} uses #{move.name}!\n#{defending.supername} #{move.success_descrip}\n#{defending.supername} takes #{move.adjusted_pts(attacking, defending)} points of damage.\n\n" + self.log
    end

    msg.html_safe
  end

  def end_of_battle_dialog
    protag = Character.find_by(id: self.protag_id)
    antag = Character.find_by(id: self.antag_id)
    if outcome == "Victory"
      msg = "#{protag.supername} is victorious!\nThey have earned #{protag.win_points(antag)} points towards leveling up.\n"
      if (protag.lvl_progress + protag.win_points(antag)) >= protag.pts_to_next_lvl
        msg += "#{protag.supername} has reached level #{protag.level + 1}!\n"
      end
      msg += "\n" + self.log
      msg.html_safe
    elsif outcome == "Defeat"
      msg = "#{protag.supername} was defeated!\n\n" + self.log
      msg.html_safe
    end
  end


  # USED ON BATTLE STATS PAGE
  def generate_outcome_severity
    # For use only on completed battles.
    result_intro = ""

    case self.outcome == "Victory" ? self.p_hp : self.a_hp
    when 1..10
      result_intro = self.outcome == "Victory" ? "Narrowly squeeked by against " : "Almost held on against "
    when 11..30
      result_intro = self.outcome == "Victory" ? "Cut it pretty close against " : "Couldn't quite close the deal against "
    when 31..70
      result_intro = self.outcome == "Victory" ? "Handily defeated " : "Could have done better against "
    when 71..100
      result_intro = self.outcome == "Victory" ? "Held their ground against " : "Wasn't a match for "
    when 101..150
      result_intro = self.outcome == "Victory" ? "Pulled off a solid win against " : "Suffered a sound defeat at the hands of "
    when 151..200
      result_intro = self.outcome == "Victory" ? "Opened a can of whoop-ass on " : "Got thrashed by "
    when 201..250
      result_intro = self.outcome == "Victory" ? "Demolished " : "Had no chance against "
    else
      result_intro = self.outcome == "Victory" ? "Went nuclear on " : "Was totally annihilated by "
    end

    return result_intro
  end

end
