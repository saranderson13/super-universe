class WelcomeController < ApplicationController

  def home
    @recent = Battle.recent_battles
    @leaders_records = Character.leader_board("protag_rank")
    @antag_records = Character.leader_board("antag_rank")
    @news = NewsItem.newsfeed
    
  end

end
