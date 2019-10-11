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
      log_in(@user)
      redirect_to user_path(@user)
    else
      render :new
    end

  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update

  end

  def destroy

  end

  # ACTIONS FOR OAUTH ALIAS SET
  def set_alias
    authorized_to_edit?
    redirect_to user_path(current_user) if !current_user.alias.include?("fieoIDOS931lD990a03")
    @user = current_user
  end

  def oauth_login_complete
    @user = current_user
    @user.alias = alias_params[:alias]
    if @user.valid?
      @user.save
      redirect_to user_path(@user)
    else
      render :set_alias
    end
  end

  private
  def signup_params
    params.require(:user).permit(:alias, :email, :password, :password_confirmation)
  end

  def alias_params
    params.require(:user).permit(:alias)
  end

end
