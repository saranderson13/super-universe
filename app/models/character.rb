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

  # has_many :battles
  # has_many :opponents, through: :battles

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
