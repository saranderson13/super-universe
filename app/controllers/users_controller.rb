class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new

  end

  def create

  end

  def show
    @user = current_user
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def current_user
    User.find_by(id: session[:user_id])
  end

end
