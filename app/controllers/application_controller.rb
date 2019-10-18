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

  # Checks if user is authorized to edit a user profile
  def authorized_to_edit?
    unless logged_in? && (current_user.id == params[:id].to_i || current_user.admin_status)
      flash[:notice] = "warning: forbidden path"
      redirect_to root_path
    end
  end

  # Checks if user is authorized to edit a character
  def authorized_to_edit_char?
    char = Character.find_by(id: params[:id])
    if !char.nil? # creating new character
      unless logged_in? && (current_user.id == char.user_id || current_user.admin_status)
        flash[:notice] = "warning: forbidden path"
        redirect_to root_path
      end
    else # editing existing character
      unless logged_in? && (current_user.id == params[:user_id].to_i || current_user.admin_status)
        flash[:notice] = "warning: forbidden path"
        redirect_to root_path
      end
    end
  end




  # BEFORE_ACTION HELPERS
  def alias_set?
    if logged_in? && current_user.alias.include?("fieoIDOS931lD990a03")
      flash[:notice] = "warning: you must complete registration by choosing an alias."
      redirect_to set_alias_path(current_user)
    end
  end

  def admin_only
    unless !!current_user && current_user.admin_status
      flash[:notice] = "warning: forbidden path"
      redirect_to root_path
    end
    # return head(:forbidden) unless !!current_user && current_user.admin_status
  end
end
