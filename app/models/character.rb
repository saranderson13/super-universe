class Character < ApplicationRecord

  validates :char_type, inclusion: { in: ["Hero", "Villain"] }
  validates :supername, presence: true
  validates :secret_identity, presence: true
  validates :bio, length: { maximum: 500 }
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
    (opponent.level - self.level) + 10
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
