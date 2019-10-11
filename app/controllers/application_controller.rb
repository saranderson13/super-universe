class ApplicationController < ActionController::Base

  before_action :alias_set?, except: [:set_alias, :oauth_login_complete]

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find_by(id: session[:user_id])
  end


  # BEFORE_ACTION HELPERS
  def alias_set?
    if logged_in? && current_user.alias.include?("fieoIDOS931lD990a03")
      redirect_to set_alias_path(current_user)
    end
  end

  def admin_only
    return head(:forbidden) unless !!current_user && current_user.admin_status
  end
end
