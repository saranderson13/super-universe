class WelcomeController < ApplicationController

  def home
    @recent = Battle.recent_battles
    @leaders_general = Character.top_supers_leader_board
    @leaders_records = Character.records_leader_board
  end

end
