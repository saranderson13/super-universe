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

  # Method to prevent people from editing other member's content
  def authorized_to_edit?
    redirect_to root_path unless logged_in? && (current_user.id == params[:id].to_i || current_user.admin_status)
  end

  def authorized_to_edit_char?
    char = Character.find_by(id: params[:id])
    redirect_to root_path unless logged_in? && (current_user.id == char.user_id || current_user.admin_status)
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
