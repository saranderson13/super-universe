class NewsItem < ApplicationRecord

    validates :title, :description, presence: true
    validates :title, length: { in: 10..150 }
    validates :description, length: { in: 50..300 }
    validates :homepage, inclusion: { in: [true, false] }

    scope :newsfeed, -> { where(homepage: true) }

end
