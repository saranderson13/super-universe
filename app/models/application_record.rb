class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include ActionView::Helpers::TextHelper

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
