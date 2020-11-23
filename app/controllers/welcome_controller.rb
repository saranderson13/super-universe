class WelcomeController < ApplicationController

  def home

    @recent = Battle.recent_battles
    @top_supers = Character.leader_board("top_supers_rank")
    @protag_records = Character.leader_board("protag_rank")
    @antag_records = Character.leader_board("antag_rank")
    @news = NewsItem.newsfeed
        
  end

end
