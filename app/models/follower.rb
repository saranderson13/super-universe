class Follower < ApplicationRecord

    belongs_to :user

    validates :user_id, :following, presence: true
    validate :validate_new_follow


    private 

    def validate_new_follow
        if User.find(self.following).is_following?(User.find(user_id))
            # Should never really get this error unless it is being created manually in terminal.
            # "Follow" button is a toggle; only shows 'follow' button if not following.
            # If already following, will only show 'unfollow' button.
            errors.add(:following, "You are already following this user.")
        end
    end
end
