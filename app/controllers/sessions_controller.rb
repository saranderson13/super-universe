class SessionsController < ApplicationController

  def new
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
      # log a vague error and reload the login form
      flash[:notice] = "Login credentials incorrect."
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to users_path
  end

  private

  # Returns user that is attempting to log in.
  # If not found by :alias & email, returns nil.
  def currently_logging_in
    binding.pry
    User.find_by(alias: params[:alias])
  end

  def login_params
    params.permit(:alias, :password, :password_confirmation)
  end

end
