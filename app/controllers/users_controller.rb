class UsersController < ApplicationController

  before_action :admin_only, only: [:index]
  # before_action :must_be_logged_in

  def index
    @users = User.all
  end

  def new
    redirect_to user_path(current_user) if logged_in?
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
    @user = set_user
    if @user.nil?
      flash[:notice] = "warning: that user does not exist."
      redirect_to root_path
    else
      @chars = @user.characters
      @followers = @user.extract_follow_users("followers")
      @following = @user.extract_follow_users("is_following")
      @suggested_users = @user.suggest_users
      @fav_opps = @user.favorites
      @fav_opps_ranks = @user.get_fave_opps_ranks
      @rand_opps = @user.random_opponents
      @rand_opps_ranks = @user.get_rand_opps_ranks
    end
  end

  def edit
    authorized_to_edit?
    @user = set_user
    if @user.nil?
      flash[:notice] = "warning: that user does not exist."
      redirect_to root_path
    end
  end

  def update
    authorized_to_edit?
    @user = set_user
    @user.assign_attributes(edit_params)
    if @user.valid?
      @user.save
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    authorized_to_edit?
    @user = set_user
    reset_session
    @user.destroy
    flash[:notice] = "CONFIRMATION: ACCOUNT DELETED"
    redirect_to root_path
  end

  # ACTIONS FOR OAUTH ALIAS SET
  def set_alias
    authorized_to_set_alias?
    @user = current_user
  end

  def oauth_login_complete
    authorized_to_set_alias?
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

  def set_user
    User.find_by(id: params[:id])
  end

  def authorized_to_set_alias?
    if !logged_in?
      redirect_to root_path
    elsif !current_user.alias.include?("fieoIDOS931lD990a03") || current_user.id != params[:id].to_i
      flash[:notice] = "Warning: forbidden path"
      redirect_to user_path(current_user)
    else
      true
    end
  end

  def signup_params
    params.require(:user).permit(:alias, :email, :password, :password_confirmation)
  end

  def alias_params
    params.require(:user).permit(:alias)
  end

  def edit_params
    params.require(:user).permit(:alias, :profile_pic, :email)
  end

end
