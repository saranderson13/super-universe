class NewsItem < ApplicationRecord

    validates :title, :description, presence: true
    validates :title, length: { in: 10..150 }
    validates :description, length: { in: 50..500 }
    validates :homepage, inclusion: { in: [true, false] }

    scope :newsfeed, -> { where(homepage: true).reverse() }


    def pretty_date
        Date.parse(self.created_at.to_s).strftime("%A, %B %-d, %Y")
    end

end
