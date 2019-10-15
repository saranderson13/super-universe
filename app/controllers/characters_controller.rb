class CharactersController < ApplicationController

  def new
    @char = Character.new()
  end

  def create

  end

  def show
    @user = set_user
    @char = set_char
    @secret_id = @char.dox("") if char_security_checks
  end

  def edit

  end

  def update

  end

  def destroy
    authorized_to_edit_char?
    @user = set_user
    @char = set_char
    flash[:notice] = "CONFIRMATION: #{@char.supername.upcase} HAS BEEN DELETED"
    @char.destroy
    redirect_to user_path(@user)
  end

  private

  def char_security_checks
    if @user.nil?
      flash[:notice] = "warning: that user does not exist."
      redirect_to root_path and return
    elsif @char.nil?
      flash[:notice] = "warning: that character does not exist."
      redirect_to user_path(@user) and return
    elsif @char.user_id != @user.id
      flash[:notice] = "warning: that character does not belong to the specified user."
      redirect_to user_path(@user) and return
    else
      return true
    end
  end

  def set_user
    User.find_by(id: params[:user_id])
  end

  def set_char
    Character.find_by(id: params[:id])
  end
end
