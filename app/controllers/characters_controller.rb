class CharactersController < ApplicationController

  def new
    @char = Character.new()
  end

  def create

  end

  def show
    @user = User.find_by(id: params[:user_id])
    @char = Character.find_by(id: params[:id])
    if @user.nil?
      flash[:notice] = "warning: that user does not exist."
      redirect_to root_path
    elsif @char.nil?
      flash[:notice] = "warning: that character does not exist."
      redirect_to user_path(@user)
    elsif @char.user_id != @user.id
      flash[:notice] = "warning: that character does not belong to the specified user."
      redirect_to user_path(@user)
    else
      @secret_id = @char.dox("")
    end
  end

  def edit

  end

  def update

  end

  def destroy
    authorized_to_edit_char?
    @user = User.find_by(id: params[:user_id])
    @char = set_char
    flash[:notice] = "CONFIRMATION: #{@char.supername.upcase} HAS BEEN DELETED"
    @char.destroy
    redirect_to user_path(@user)
  end

  private

  def set_char
    Character.find_by(id: params[:id])
  end
end
