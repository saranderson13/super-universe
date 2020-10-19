class Character < ApplicationRecord

  validates :char_type, inclusion: { in: ["Hero", "Villain"] }
  validates :supername, presence: true
  validates :secret_identity, presence: true
  validates :bio, length: { maximum: 400 }
  validate :validate_stats
  validate :validate_alignment

  belongs_to :user
  # belongs_to :team

  has_many :character_powers
  has_many :powers, through: :character_powers

  has_many :protag_battles, class_name: 'Battle', foreign_key: :protag_id
  has_many :antag_battles, class_name: 'Battle', foreign_key: :antag_id
  has_many :antags, through: :protag_battles

  scope :teamless,  -> { where(team_id: 0) }
  scope :hero, -> { where(char_type: "Hero") }
  scope :villain, -> { where(char_type: "Villain") }

  VILL_ALIGNMENT = ["Lawful Neutral", "True Neutral", "Chaotic Neutral", "Lawful Evil", "Neutral Evil", "Chaotic Evil"]
  HERO_ALIGNMENT = ["Lawful Good", "Neutral Good", "Chaotic Good", "Lawful Neutral", "True Neutral", "Chaotic Neutral"]


  def dox_code=(code)
    hashed_code = (code == "-" ? "" : MurmurHash3::V32.str_hash(code))
    super(hashed_code)
  end

  def dox(code)
    return self.secret_identity if self.dox_code == ""
    MurmurHash3::V32.str_hash(code).to_s == self.dox_code ? self.secret_identity : "REDACTED"
  end

  def self.all_alignments
    [HERO_ALIGNMENT, VILL_ALIGNMENT].flatten.uniq
  end

  # NOT CURRENTLY IN USE
  def find_opponents
    Character.all.select { |c| c.protag_battle_ready?(self) }
  end

  def non_pending_battles(role)
    # Call with "protag" or "antag" as role.
    self.send("#{role}_battles").select { |b| b if b.outcome != "Pending" }
  end

  def chronological_battles 
    self.non_pending_battles("protag").sort_by { |b| b.updated_at }.reverse()
  end
  
  def recent_battles
    self.chronological_battles[0..4]
  end
  
  
  

  # METHODS TO DETERMINE BATTLE STATISTICS
  def past_opponents
    self.non_pending_battles("protag").map { |b| b.antag }.uniq()
  end

  def spar_record(antag)
    battles = self.non_pending_battles("protag").select { |b| b.antag == antag }
    record = {
      opponent: antag,
      victories: 0,
      defeats: 0
    }

    battles.each do |b|
      b.outcome == "Victory" ? record[:victories] += 1 : record[:defeats] += 1
    end

    return record
  end

  def win_percentage
    if self.victories == 0
      return 0
    elsif self.defeats == 0
      return 100
    else
      return ((self.victories.to_f() / self.non_pending_battles("protag").length) * 100).to_i()
    end
  end

  def antag_battle_record 
    record = {
      victories: 0,
      defeats: 0
    }
    self.non_pending_battles("antag").each do |b|
      b.outcome == "Victory" ? record[:defeats] += 1 : record[:victories] += 1
    end

    return [record[:victories], record[:defeats]]
  end

  def antag_battle_win_percentage
    abr = self.antag_battle_record()
    if abr[0] == 0
      return 0
    elsif abr[1] == 0
      return 100
    else
      return ((abr[0].to_f() / (abr[0] + abr[1])) * 100).to_i()
    end
  end

  def detect_current_streak
    outcomes = self.chronological_battles.map { |b| b.outcome }
    type, breaker = outcomes[0], outcomes[0] == "Victory" ? "Defeat" : "Victory"
    streak = 0

    outcomes.each do |o| 
      streak += 1 if o == type 
      break if o == breaker
    end

    return [type, streak]
  end

  def detect_hot_streak 
    streak = self.detect_current_streak
    return streak[0] == "Victory" && streak[1] >= 5
  end

  def detect_cold_streak
    streak = self.detect_current_streak
    return streak[0] == "Defeat" && streak[1] >= 5
  end

  def longest_streak(type)
    # call with "Victory" for win streak;
    # call with "Defeat" for losing streak
    outcomes = self.chronological_battles.map { |b| b.outcome }
    longest_streak, streak = 0, 0

    outcomes.each do |o|
      o == type ? streak += 1 : streak = 0
      longest_streak = streak if streak >= longest_streak
    end

    return longest_streak
  end

  def record_rank
    Character.records_rank.find_index(self) + 1
  end

  def top_supers_rank
    Character.top_supers_rank.find_index(self) + 1
  end






  # TO DETERMINE CHARACTER BATTLE ELIGABILITY
  def not_self?(antag)
    self.id != antag.id
  end

  def has_superpowers?
    self.powers.count > 0
  end

  def no_battles_in_progress?
    !self.protag_battles.any? { |b| b.outcome == "Pending" }
  end

  def battle_in_progress
    self.protag_battles.in_progress[0]
  end

  def opposite_char_type?(antag)
    if self.char_type == "Hero"
      antag.char_type == "Villain"
    elsif self.char_type == "Villain"
      antag.char_type == "Hero"
    end
  end

  def protag_battle_ready?(antag)
    self.not_self?(antag) && self.has_superpowers? && self.no_battles_in_progress? && self.opposite_char_type?(antag)
  end






  # BATTLE METHODS
  def antag_def_adjustment
    (1 - (self.def/500.0))/2
  end

  def protag_att_adjustment
    1 + (self.att/500.0)
  end

  def dodge?
    arr = []
    ((self.antag_def_adjustment * 100).to_i).times { arr << true }
    (100 - arr.count).times { arr << false }
    arr.sample
  end

  def protag_attacks(battle)
    attacks = []
    self.powers.each do |p|
      p.moves.each do |m|
        attacks << m if m.move_type == "att"
        attacks << m if m.move_type == "pwr" unless battle.p_used_pwrmv == true
      end
    end
    attacks
  end

  def antag_attack(battle)
    attacks = []
    self.powers.each do |p|
      p.moves.each do |m|
        attacks << m if m.move_type == "att"
        attacks << m if m.move_type == "pwr" unless battle.a_used_pwrmv == true
      end
    end
    attacks.sample
  end

  def win_points(opponent)
    points = (opponent.level - self.level) + 10
    points < 0 ? 0 : points # Ensures that win points are never less than 0.
  end

  def victory_results(opponent)
    self.victories += 1
    self.lvl_progress += self.win_points(opponent)
    while self.lvl_progress >= self.pts_to_next_lvl
      self.level += 1
      self.lvl_progress -= self.pts_to_next_lvl
      self.pts_to_next_lvl = self.level * 10
    end
    self.save
  end

  def defeat_results
    self.defeats += 1
    self.save
  end

  def hp_lvl_adjust
    self.hp + (self.level * 10)
  end





  # CHARACTER RANKING FUNCTIONS

  def win_loss_ratio(numerator, denominator)
    # To rank by win, call with ("victories", "defeats")
    # To rank by losses, call with ("defeats", "victories")

    if self.send(denominator) != 0 
      return self.send(numerator).to_f / self.send(denominator)
    else
      return self.non_pending_battles("protag").length == 0 ? 0 : self.send(numerator).to_f + 1
    end
  end
  
  def self.top_supers_rank
    groups = {
      winning_record: [],
      losing_record: []
    }

    self.all.each { |c| c.win_loss_ratio("victories", "defeats") > 1 ? groups[:winning_record].push(c) : groups[:losing_record].push(c) }

    w_sorted = groups[:winning_record].sort_by { |c| [c.level, c.lvl_progress, c.win_loss_ratio("victories", "defeats"), c.victories] }.reverse()
    l_sorted = groups[:losing_record].sort_by { |c| [c.level, c.lvl_progress, c.win_loss_ratio("victories", "defeats"), c.victories] }.reverse()

    return w_sorted.concat(l_sorted)
  end

  def self.top_supers_leader_board
    self.top_supers_rank[0..4]
  end

  def self.records_rank
    groups = {
      winning_record: [],
      losing_record: []
    }

    self.all.each { |c| c.win_loss_ratio("victories", "defeats") > 1 ? groups[:winning_record].push(c) : groups[:losing_record].push(c) }

    w_sorted = groups[:winning_record].sort_by { |c| [c.victories, c.win_percentage, c.win_loss_ratio("victories", "defeats"), c.non_pending_battles("protag").length, c.level, c.lvl_progress] }.reverse
    l_sorted = groups[:losing_record].sort_by { |c| [c.victories, c.win_percentage, c.win_loss_ratio("victories", "defeats"), c.non_pending_battles("protag").length, c.level, c.lvl_progress] }.reverse
  
    return w_sorted.concat(l_sorted)
  end

  def self.records_leader_board
    self.records_rank[0..4]
  end

  def self.wall_of_shame
    return self.all.sort_by { |c| [c.defeats, c.win_loss_ratio("defeats", "victories")]}.reverse[0..4]
  end

  def self.records_rank_print
    self.records_rank.each do |c|
      puts <<~HEREDOC
      Name: #{c.supername}
      Victories: #{c.victories}
      Win %: #{c.win_percentage}
      Win Ratio: #{c.win_loss_ratio("victories", "defeats")}
      Total Battles: #{c.non_pending_battles("protag").length}
      Level: #{c.level}
      Lvl Progress: #{c.lvl_progress}

      HEREDOC
    end
  end






  private

  def validate_stats
    if (self.hp == nil || self.hp <= 0) || (self.att == nil || self.att <= 0) || (self.def == nil || self.def <= 0)
      if self.hp == nil || self.att == nil || self.def == nil
        errors.add(:hp, "All stats must have a value.")
        errors.add(:att, "All stats must have a value.")
        errors.add(:def, "All stats must have a value.")
      elsif self.hp <= 0 || self.att <=0 || self.def <=0
        errors.add(:hp, "All stats must be greater than 0.")
        errors.add(:att, "All stats must be greater than 0.")
        errors.add(:def, "All stats must be greater than 0.")
      end
    else
      if self.hp + self.att + self.def > 500
        errors.add(:hp, "sum of HP, ATT and DEF may not exceed 500.")
        errors.add(:att, "sum of HP, ATT and DEF may not exceed 500.")
        errors.add(:def, "sum of HP, ATT and DEF may not exceed 500.")
      end
    end
  end

  def validate_alignment
    if self.char_type == "Villain"
      errors.add(:alignment, "Alignment outside of the 'villain' range.") if !VILL_ALIGNMENT.include?(self.alignment)
    elsif self.char_type == "Hero"
      errors.add(:alignment, "Alignment outside of the 'hero' range.") if !HERO_ALIGNMENT.include?(self.alignment)
    else
      errors.add(:char_type, "Please declare a character type.")
    end
  end


end
