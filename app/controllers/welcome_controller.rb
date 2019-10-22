class WelcomeController < ApplicationController

  def home
    @recent = Battle.recent_battles
  end

end
