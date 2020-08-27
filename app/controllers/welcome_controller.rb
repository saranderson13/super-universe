class WelcomeController < ApplicationController

  def home
    @recent = Battle.recent_battles
    @leaders_general = Character.leader_board_general
  end

end
