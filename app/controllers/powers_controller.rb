class PowersController < ApplicationController

  before_action :must_be_logged_in
  helper_method :characters_for_add_power

  def index
    @powers = Power.all
    @pe_pwrs = @powers.physical_enhancements
    @me_pwrs = @powers.mental_enhancements
    @em_pwrs = @powers.elemental_masteries
    @ma_pwrs = @powers.magical_abilities
  end

  def show
    @power = Power.find_by(id: params[:id])
    if !@power.nil?
      @att = @power.fetch_move("att")
      @pwr = @power.fetch_move("pwr")
      @characters = characters_for_add_power if (logged_in? && !current_user.nil?)
    else
      flash[:notice] = "Warning: That power does not exist."
      redirect_to powers_path
    end
  end

  private

  def characters_for_add_power
    pwr = Power.find(params[:id])
    current_user.characters.map { |c| c if (c.powers.count < 3 && !c.powers.include?(pwr)) }.compact
  end

end
