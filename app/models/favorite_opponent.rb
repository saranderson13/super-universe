class FavoriteOpponent < ApplicationRecord

    validates :user_id, :character_id, presence: true

    belongs_to :user
    belongs_to :character

end
