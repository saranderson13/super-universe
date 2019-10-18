class CharacterPowersController < ApplicationController

  # '/characters/add_power'
  # form found on 'power/:id' page
  def add
    char = set_char_from_pwr_form
    pwr = set_pwr_from_pwr_form
    authorized_to_add_pwr?
    if powers_full?
      flash[:notice] = "#{char.supername}'s powers are full. Delete one to proceed."
      redirect_to power_path(pwr) and return
    elsif power_duplicate?
      flash[:notice] = "#{char.supername} already has that power."
      redirect_to power_path(pwr) and return
    else
      char.powers << pwr
      redirect_to user_character_path(user_id: char.user_id, id: char.id)
    end
  end

  # '/characters/:id/powers'
  def show

  end

  def destroy

  end

  private

  def set_char_from_pwr_form
    Character.find_by(id: addpwr_params[:character])
  end

  def set_pwr_from_pwr_form
    Power.find_by(id: addpwr_params[:power_id])
  end

  def addpwr_params
    params.permit(:power_id, :character)
  end

  def authorized_to_add_pwr?
    char = set_char_from_pwr_form
    unless !!logged_in? && (current_user.id == char.user_id || current_user.admin_status)
      flash[:notice] = "warning: you do not have permission to do that"
      redirect_to power_path(id: addpwr_params[:power_id])
    end
  end

  def powers_full?
    char = set_char_from_pwr_form
    !!(char.powers.count == 3)
  end

  def power_duplicate?
    char = set_char_from_pwr_form
    !!(char.powers.include?(Power.find_by(id: addpwr_params[:power_id])))
  end

end
