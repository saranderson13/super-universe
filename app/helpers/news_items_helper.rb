module NewsItemsHelper

    def news_form_error(field)
        case field
        when :title
            "!! News title length is invalid. Must be between 10 - 150 characters. You have used #{@news_item.title.length}/500 characters." if !@news_item.errors[:title].empty?
        when :description
            "!! News description length is invalid. Must be between 50 - 500 characters. You have used #{@news_item.description.length}/500 characters." if !@news_item.errors[:description].empty?
        end
    end


end
