class NewsItem < ApplicationRecord

    validates :title, :description, presence: true
    validates :title, length: { maximum: 150, minimum: 10 }
    validates :description, length { maximum: 500, minimum: 100 }
    validates :homepage, inclusion: { in: [true, false] }

    scope :newsfeed, -> { where(homepage: true) }

end
