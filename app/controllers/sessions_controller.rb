class SessionsController < ApplicationController

  # TRADITIONAL LOGIN
  def new
    redirect_to user_path(current_user) if logged_in?
  end

  def create
    user = currently_logging_in
    # if user is found and password is correct
    if !!user && user.authenticate(login_params[:password])
      # log the user in by adding their id to the session hash
      # redirect to their profile page
      session[:user_id] = user.id
      redirect_to user_path(user)
    else # if the user is not found or the password is incorrect
      # log a vague error and redirect_to login form
      flash[:notice] = "login credentials incorrect."
      redirect_to :login
    end
  end

  # OAUTH LOGIN - GOOGLE
  def googleAuth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    @user = User.from_omniauth(access_token)

    # Access_token is used to authenticate request made from the rails application to the google server.
    # Use this if planning to use Google APIs (Calendar/sheets/etc)
    @user.google_token = access_token.credentials.token

    # Refresh_token to request a new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    @user.google_refresh_token = refresh_token if refresh_token.present?

    # Persist and log in user
    @user.save
    log_in(@user)

    # If user is new (meaning they still have the default alias) redirect them to set up their alias.
    # else direct them as usual.
    if @user.alias.include?("fieoIDOS931lD990a03")
      redirect_to set_alias_path(@user)
    else
      redirect_to user_path(@user)
    end
  end



  # LOG OUT
  def destroy
    reset_session
    redirect_to root_path
  end

  private

  # Returns user that is attempting to log in.
  # If not found by :alias, returns nil.
  def currently_logging_in
    User.find_by(alias: params[:alias])
  end

  def login_params
    params.permit(:alias, :password, :password_confirmation)
  end

end
