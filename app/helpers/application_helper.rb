module ApplicationHelper

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def navbar
    if logged_in?
      render 'layouts/logged_in_navbar'
    else
      render 'layouts/logged_out_navbar'
    end
  end

  def user_show_page_greeting
    if logged_in? && current_user.id == params[:id].to_i
      "Welcome, #{@user.alias}"
    else
      "#{@user.alias}"
    end
  end

  def current_user_profile_links
    render 'layouts/cu_profile_links' if logged_in? && (current_user.id == params[:id].to_i || current_user.admin_status)
  end

  def char_edit_links
    render 'layouts/char_edit_links' if logged_in? && (current_user.id == params[:user_id].to_i || current_user.admin_status)
  end

  def secret_id_class
    if @secret_id == "REDACTED"
      redacted = "<span class='redacted'>#{@secret_id}</span>"
      redacted.html_safe
    else
      revealed = "<span class='revealed'>#{@secret_id}</span>"
      revealed.html_safe
    end
  end

end
