class User < ApplicationRecord

  has_secure_password

  validates :alias, presence: true
  validates :alias, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, confirmation: true, unless: -> { password.blank? }
  validates :admin_status, inclusion: { in: [true, false] }

  has_many :characters
  has_many :protag_battles, through: :characters
  has_many :antag_battles, through: :characters

  # To create a fave:
    # self.favorite_opponents.new(character_id: [id of char to fave])
  has_many :favorite_opponents
  has_many :favorites, through: :favorite_opponents, source: :character

  # To create a follower:
    # self.followers.new(following: [user_id of the user that is requesting to follow them.])
  has_many :followers


  # FUTURE ASSOCIATIONS
  # has_many :teams, through: :characters
  #
  # has_many :plikes
  # has_many :powers, through: :plikes

  scope :admin, -> { where(admin_status: true) }

  ANTAG_RANK_WGCRIT = { antag_victories: 5, antag_opponent_count: 4, antag_win_percentage: 3, antag_battle_count: 4, level: 2 }
  ANTAG_RANK_LGCRIT = { antag_victories: 5, antag_opponent_count: 4, antag_win_percentage: 3, antag_battle_count: -2, level: 2 }
  ANTAG_RANK_WLARGS = ["Defeat", "Victory", "antag"]

  PROTAG_RANK_WGCRIT = { protag_victories: 5, protag_opponent_count: 4, protag_win_percentage: 3, protag_battle_count: 4, level: 2 }
  PROTAG_RANK_LGCRIT = { protag_victories: 5, protag_opponent_count: 4, protag_win_percentage: 3, protag_battle_count: -2, level: 2 }
  PROTAG_RANK_WLARGS = ["Victory", "Defeat", "protag"]

  TOP_SUPERS_RANK_WGCRIT = { all_victories: 5, total_opponent_count: 4, overall_win_percentage: 3, total_battle_count: 4, level: 2 }
  TOP_SUPERS_RANK_LGCRIT = { all_victories: 5, total_opponent_count: 4, overall_win_percentage: 3, total_battle_count: -2, level: 2 }
  TOP_SUPERS_RANK_WLARGS = ["", "", "overall"]

  def opponents(type)
    pool = []
    Character.send(type).each { |c| pool.push(c) if c.user_id != self.id && c.has_superpowers? }
    pool.sample(5)
  end

  # FOR OAUTH LOGIN
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.alias = "fieoIDOS931lD990a03#{auth[:uid]}"
      user.email = auth.info.email
      user.password = Sysrandom.base64(32)
    end
  end

  def eligable_chars(antag)
    self.characters.select { |c| c if c.protag_battle_ready?(antag) }
  end

  def is_admin?
    !!self.admin_status
  end

  def extract_follow_users(followerOrFollowing)
    id_code = followerOrFollowing == "followers" ? "following" : "user_id"
    self.send(followerOrFollowing).map { |f| User.find(f.send(id_code)) }
  end

  def is_following
    Follower.all.select { |f| f.following == self.id }
  end

  def is_following?(user_to_follow_id) 
    !!self.is_following.include?(Follower.find_by(user_id: user_to_follow_id, following: self.id))
  end

  def follower_count
    self.followers.length
  end

  def following_count
    self.is_following.length
  end

  def has_faved?(character_id)
    !!self.favorites.include?(Character.find(character_id))
  end

  def random_opponents
    possible_opponents = []
    Character.all.each do |c|
      possible_opponents.push(c) if self.suggested_opponent_levels.include?(c.level) && c.user != self && !self.favorites.include?(c)
    end
    return possible_opponents.sample(9)
  end

  def suggested_opponent_levels
    opp_levels = []
    self.characters.map { |c| c.level }.uniq.each do |l|
      opp_levels.push(l, l + 1)
      opp_levels.push(l - 1) if l - 1 > 0
    end
    return opp_levels.uniq
  end

  def get_fave_opps_ranks
    Character.quick_ranks(ANTAG_RANK_WLARGS, ANTAG_RANK_WGCRIT, ANTAG_RANK_LGCRIT, self.favorites)
  end

  def get_rand_opps_ranks
    Character.quick_ranks(ANTAG_RANK_WLARGS, ANTAG_RANK_WGCRIT, ANTAG_RANK_LGCRIT, self.random_opponents)
  end

end
