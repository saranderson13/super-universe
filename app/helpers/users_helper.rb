module UsersHelper

  # On User Show Pg - shows "Welcome, :alias" if viewing current user's profile.
  # Otherwise just shows :alias.
  def user_show_page_greeting
    if logged_in? && current_user.id == params[:id].to_i
      "Welcome, #{@user.alias}"
    else
      "#{@user.alias}"
    end
  end

  # On User Show Pg - Shows edit/delete user buttons if viewing current user's page or if current user is admin.
  # Otherwise does not show them.
  def current_user_profile_links
    render 'layouts/cu_profile_links' if logged_in? && (current_user.id == params[:id].to_i || current_user.admin_status)
  end

end
