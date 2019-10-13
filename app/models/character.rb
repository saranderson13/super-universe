class Character < ApplicationRecord

  validates :type, inclusion: { in: ["Hero", "Villain"] }
  validates :supername, presence: true
  validates :secret_identity, presence: true
  validates :bio, length: { maximum: 1000 }
  validate :validate_stats

  belongs_to :user
  # belongs_to :team
  #
  # has_many :superpowers
  # has_many :powers, through: :superpowers
  #
  # has_many :battles
  # has_many :opponents, through: :battles

  scope :teamless,  -> { where(team_id: 0) }
  scope :hero, -> { where(type: "Hero") }
  scope :villain, -> { where(type: "Villain") }

  private

  def validate_stats
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
