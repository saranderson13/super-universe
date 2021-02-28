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

  # THESE CONSTANTS ARE IDENTICAL IN character MODEL - REMEMBER TO SYNC CHANGES
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



  # FOR MANAGING FOLLOWS/FOLLOWING 
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

  def suggest_users
    # Suggest users based on who the people you are following are following

    # Get ids for all currently followed users.
    following_ids = self.is_following.map { |u| u.user_id }
    
    # If there are no followed users, return 10 random users
    if following_ids.empty?
      return User.all.sample(10).reject { |u| u.id == self.id }
    
    # If there are followed users...
    else
      # Set up commonly_followed hash by creating creating a key for every unfollowed user (that isn't self)
      # and set value of that key to 0.
      # Also set up array of unfollowed users to pull from if algorithm suggests fewer than 10 users.
      unfollowed = []
      commonly_followed = {}
      User.all.each do |u| 
        if u.id != self.id && !following_ids.include?(u.id)
          unfollowed.push(u)
          commonly_followed[u.id] = 0 
        end
      end
      
      # Iterate over all Follows.
      # If there is a key for the user that is being followed
      # And the user id of the follower is in your following_ids hash
      # add 1 to the value of that key.
      # also remove that user from the unfollowed array.
      Follower.all.each do |f|
        if !!commonly_followed[f.user_id] && following_ids.include?(f.following)
          unfollowed.delete(User.find(f.user_id))
          commonly_followed[f.user_id] += 1
        end
      end


      # Iterate through the commonly_followed hash.
      # Push a user into the #suggested_users array #common_count times.
      # (so if a user is followed by 3 of the users you are following, push them into the #suggested_users array 3 times)
      # Then shuffle the array so that users are in a random order instead of clumped together.
      suggested_users = []
      commonly_followed.each do |user_id, common_count|
        common_count.times do
          suggested_users.push(User.find(user_id))
        end
      end

      # Add unfollowed users into the #suggested_users array.
      # They will be present 1 time each.
      # Shuffle the resulting array and return an array of 10 random users, made to be unique.
      suggested_users.concat(unfollowed)
      suggested_users.shuffle!
      return suggested_users.sample(10).uniq

    end
  end



  # FOR MANAGING FAVE CHARACTERS
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
