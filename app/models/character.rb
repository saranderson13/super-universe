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
  def past_opponents(character_as)
    opponent_type  = character_as == "protag" ? "antag" : "protag"

    self.non_pending_battles(character_as).map { |b| b.send(opponent_type) }.uniq()
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

  def character_rank(rank_type)
    # call with "protag_rank" for Top Supers (best protags)
    # call with "antag_rank" for Toughest Antagonists (best antags)
    self.non_pending_battles("protag").length == 0 ? 0 : Character.send(rank_type).find_index(self) + 1
  end

  # DEPRECATED
    # def top_supers_rank
    #   self.non_pending_battles("protag").length == 0 ? 0 : Character.top_supers_rank.find_index(self) + 1
    # end






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

  def protag_attacks_for_printout(battle)
    attacks = {}
    self.powers.each do |p|
      attacks[p] = []
      p.moves.each { |m| attacks[p] << m }
    end
    attacks
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

  def stats_after_lvlup(opponent)
    stats = {
      new_lvl: self.level,
      lvl_progress: self.lvl_progress,
      pts_to_next: self.pts_to_next_lvl,
      new_nxt_lvl: self.level + 1
    }
    
    stats[:lvl_progress] = self.lvl_progress + self.win_points(opponent)
    
    while stats[:lvl_progress] >= stats[:pts_to_next]
      stats[:new_lvl] += 1
      stats[:lvl_progress] -= stats[:pts_to_next]
      stats[:pts_to_next] = stats[:new_lvl] * 10
    end

    stats[:new_nxt_lvl] = stats[:new_lvl] + 1
    stats
  end




  # CHARACTER RANKING FUNCTIONS

  def win_loss_ratio(numerator, denominator, protag_antag)
    # To rank by win, call with ("victories", "defeats")
    # To rank by losses, call with ("defeats", "victories")
    # Call with "protag" for protag ranking, "antag" for antag ranking
    # Reverse "victories" and "defeats" for antag ranking
    # E.G. to find antag win ratio, use #win_loss_ratio("Defeat", "Victory", "antag")

    n = self.non_pending_battles(protag_antag).select { |b| b.outcome == numerator }.length
    d = self.non_pending_battles(protag_antag).select { |b| b.outcome == denominator }.length

    if d != 0 && n != 0
      return n.to_f / d
    else
      return self.non_pending_battles(protag_antag).length == 0 || n == 0 ? 0 : n + 1
    end
  end

  def wl_ratio_group(numerator, denominator, protag_antag)
    self.win_loss_ratio(numerator, denominator, protag_antag) > 1 ? :winning_record : :losing_record
  end

  def self.split_to_wl_arrays(numerator, denominator, protag_antag)
    groups = {
      winning_record: [],
      losing_record: []
    }
    self.all.each { |c| groups[c.wl_ratio_group(numerator, denominator, protag_antag)].push(c) }
    return groups
  end

  def self.leader_board(board_name)
    self.send(board_name)[0..4]
  end

  def character_rankables 
    # returns a hash with all rankable statistics for a character.
    return {
      level: self.level,
      lvl_progress: self.lvl_progress,
      protag_victories: self.victories,
      protag_defeats: self.defeats,
      protag_win_percentage: self.win_percentage,
      protag_battle_count: self.non_pending_battles("protag").length,
      protag_opponent_count: self.past_opponents("protag").length,
      antag_victories: self.antag_battle_record[0],
      antag_defeats: self.antag_battle_record[1],
      antag_win_percentage: self.antag_battle_win_percentage,
      antag_battle_count: self.non_pending_battles("antag").length,
      antag_opponent_count: self.past_opponents("antag").length
    }
  end

  def translate_rankables_for_print
    return {
      level: "Level: ",
      lvl_progress: "Level Progress: ",
      protag_victories: "Victories: ",
      protag_defeats: "Defeats: ",
      protag_win_percentage: "Win %: ",
      protag_battle_count: "Total Battles: ",
      protag_opponent_count: "Total Opponents: ",
      antag_victories: "Victories: ",
      antag_defeats: "Defeats: ",
      antag_win_percentage: "Win %: ",
      antag_battle_count: "Total Battles: ",
      antag_opponent_count: "Total Opponents: "
    }
  end

  def char_rank_stats(ranking_args, win_group_criteria, loss_group_criteria)
    # Returns hash including only the rankables that are being considered in the ranking agorithm for a given character.
    # (To be used to package stat variables for hover in leader board.)
    weights = self.wl_ratio_group(*ranking_args) == :winning_record ? win_group_criteria : loss_group_criteria
    categories = self.wl_ratio_group(*ranking_args) == :winning_record ? win_group_criteria.keys : loss_group_criteria.keys
    all_char_stats = self.character_rankables

    rank_char_stats = {}
    all_char_stats.keys.select { |cat| categories.include?(cat) }.each do |cat|
      rank_char_stats[cat] = all_char_stats[cat]
      rank_char_stats[:lvl_progress] = all_char_stats[:lvl_progress] if cat == :level
    end

    rank_char_stats[:weighted_score] = self.weighted_stat_calc(weights)

    return rank_char_stats
  end

  def char_rank_print(ranking_args, win_group_criteria, loss_group_criteria)
    # Prints rankables that are being considered in the ranking algorithm for a given character.
    weights = self.wl_ratio_group(*ranking_args) == :winning_record ? win_group_criteria : loss_group_criteria
    categories = self.wl_ratio_group(*ranking_args) == :winning_record ? win_group_criteria.keys : loss_group_criteria.keys
    char_stats = self.character_rankables

    puts "Name: #{self.supername}"
    categories.each do |cat|
      puts "#{translate_rankables_for_print[cat]}#{char_stats[cat]}"
      puts "Level Progress: #{char_stats[:lvl_progress]}" if cat == :level
    end
    puts "Weighted Score: #{self.weighted_stat_calc(weights)}"
    puts "- - - - - - - -"

  end

  def weighted_stat_calc(weights)
    # receives hash of statistical weights, e.g.:
      # { level: 3, protag_victories: 5, protag_opponent_count: 4 }
      # WEIGHTS SHOULD BE INTEGERS 1 - 5.
      # You CAN have two variables with the same weight.
      # Weight hash is NOT required to have all keys from the #character_rankables,
      # but any desired stat must have the same key name.
    # NOTE THAT IF INCLUDING LEVEL, LEVEL PROGRESS WILL BE INHERENTLY FACTORED IN
    # returns a character score as an integer

    stats = self.character_rankables
    variables = weights.keys
    sum_of_weights = weights.values.sum
    score = 0

    variables.each do |v|
      if v == :level
        score += (self.base_lvl_pts_for_weighted_stat) * self.weight_as_modifier(weights[v], sum_of_weights)
      elsif v == :protag_win_percentage
        score += (adjusted_win_percentage_for_weighted_stat(stats[v]) * self.weight_as_modifier(weights[v], sum_of_weights))
      else 
        score += stats[v] * self.weight_as_modifier(weights[v], sum_of_weights)
      end
    end
    return score

  end

  def base_lvl_pts_for_weighted_stat
    return self.level + (self.lvl_progress / 10.0)
  end

  def weight_as_modifier(weight, sum_of_weights)
    return (weight / sum_of_weights.to_f) * 10
  end

  def adjusted_win_percentage_for_weighted_stat (percentage)
    return percentage / 10.0
  end


  # MASTER RANKING ALGORITHM
  def self.rank_category_calculator(wl_args, wg_criteria, lg_criteria)

    groups = Character.split_to_wl_arrays(*wl_args)

    w_records = groups[:winning_record].map { |c| [c, c.weighted_stat_calc(wg_criteria)] }
    l_records = groups[:losing_record].map { |c| [c, c.weighted_stat_calc(lg_criteria)] }

    sorted_records = w_records.concat(l_records).sort_by { |c| c[1] }
    rankings = sorted_records.map { |c| c[0] }.reverse
    
    # UNCOMMENT TO PRINT IN TERMINAL
    # rankings.each { |c| c.char_rank_print(wl_args, wg_criteria, lg_criteria) }

    return rankings

  end


  # Best Protag Records Ranking
  
  def self.protag_rank
    wg_criteria = { protag_victories: 5, protag_opponent_count: 4, protag_win_percentage: 3, protag_battle_count: 4, level: 2 }
    lg_criteria = { protag_victories: 5, protag_opponent_count: 4, protag_win_percentage: 3, protag_battle_count: -2, level: 2 }

    self.rank_category_calculator(["Victory", "Defeat", "protag"], wg_criteria, lg_criteria)
  end


  # Toughest Antag Ranking 
  
  def self.antag_rank
    wg_criteria = { antag_victories: 5, antag_opponent_count: 4, antag_win_percentage: 3, antag_battle_count: 4, level: 2 }
    lg_criteria = { antag_victories: 5, antag_opponent_count: 4, antag_win_percentage: 3, antag_battle_count: -2, level: 2 }

    self.rank_category_calculator(["Defeat", "Victory", "antag"], wg_criteria, lg_criteria)
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
