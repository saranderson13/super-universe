class Character < ApplicationRecord

  validates :char_type, inclusion: { in: ["Hero", "Villain"] }
  validates :supername, presence: true
  validates :secret_identity, presence: true
  validates :bio, length: { maximum: 1000 }
  validate :validate_stats
  validate :validate_alignment

  belongs_to :user
  # belongs_to :team
  #
  # has_many :superpowers
  # has_many :powers, through: :superpowers
  #
  # has_many :battles
  # has_many :opponents, through: :battles

  scope :teamless,  -> { where(team_id: 0) }
  scope :hero, -> { where(char_type: "Hero") }
  scope :villain, -> { where(char_type: "Villain") }

  VILL_ALIGNMENT = ["Lawful Neutral", "True Neutral", "Chaotic Neutral", "Lawful Evil", "Neutral Evil", "Chaotic Evil"]
  HERO_ALIGNMENT = ["Lawful Good", "Neutral Good", "Chaotic Good", "Lawful Neutral", "True Neutral", "Chaotic Neutral"]

  private

  def validate_stats
    if self.hp == nil || self.att == nil || self.def == nil
      errors.add(:hp, "Please enter a value for your character's hitpoints stat.") if self.hp == nil
      errors.add(:att, "Please enter a value for your character's attack stat.") if self.att == nil
      errors.add(:def, "Please enter a value for your character's defense stat.") if self.def == nil
    else
      errors.add(:hp, "Hitpoints must be greater than 0.") if self.hp <= 0
      errors.add(:att, "Attack stat must be greater than 0.") if self.att <= 0
      errors.add(:def, "Defense stat must be greater than 0.") if self.def <= 0

      if self.hp + self.att + self.def > 500
        errors.add(:hp, "The sum of hitpoints, attack and defense must not exceed 500.")
        errors.add(:att, "Please adjust the balances for your characters stats accordingly.")
        errors.add(:def, "Thank you!")
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
