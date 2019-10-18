class PowersController < ApplicationController

  helper_method :characters_for_add_power

  def index
    @powers = Power.all
  end

  def show
    @power = Power.find_by(id: params[:id])
    @att = @power.fetch_move("att")
    @def = @power.fetch_move("def")
    @pwr = @power.fetch_move("pwr")
    @characters = characters_for_add_power if (logged_in? && !current_user.nil?)
  end

  private

  def characters_for_add_power
    pwr = Power.find(params[:id])
    current_user.characters.map { |c| c if (c.powers.count < 3 && !c.powers.include?(pwr)) }.compact
  end

end
