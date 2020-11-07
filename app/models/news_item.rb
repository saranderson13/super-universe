class NewsItem < ApplicationRecord

    validates :title, :description, presence: true
    validates :title, length: { in: 10..150 }
    validates :description, length: { in: 50..500 }
    validates :homepage, inclusion: { in: [true, false] }

    scope :newsfeed, -> { where(homepage: true).reverse() }


    def ago(createdAtOrUpdatedAt)
        # call with "created_at" OR "updated_at"

        diff = TimeDifference.between(Time.now.utc, Time.parse(self.send(createdAtOrUpdatedAt).to_s))

        if diff.in_seconds < 60
            return "#{pluralize(diff.in_seconds.to_i, 'second')} ago"
        elsif diff.in_minutes < 60
            return "#{pluralize(diff.in_minutes.to_i, 'minute')} ago"
        elsif diff.in_hours < 24
            return "#{pluralize(diff.in_hours.to_i, 'hour')} ago"
        else
            return "#{pluralize(diff.in_days.to_i, 'day')} ago"
        end
    end

end
