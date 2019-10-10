class UsersController < ApplicationController

  before_action :admin_only, only: [:index]

  def index
    @users = User.all
  end

  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(signup_params)

    if @user.valid? && @user.authenticate(signup_params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render :new
    end

  end

  def show
    @user = User.find(params[:id])
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def signup_params
    params.require(:user).permit(:alias, :email, :password, :password_confirmation)
  end

  def admin_only
    return head(:forbidden) unless !!current_user && current_user.admin_status
  end

end
