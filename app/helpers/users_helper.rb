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


  def user_battles_in_progress
    viewing = User.find(params["id"])
    if viewing.protag_battles.in_progress.length > 0
      in_progress = <<~HEREDOC
      <div class='user_bip_title'>#{viewing.protag_battles.in_progress.count} battles in progress</div>
      <div class='bip_links'>#{user_battles_in_progress_list}</div>
      HEREDOC
      return in_progress.html_safe
    else
      "<div class='user_bip_title'>No battles in progress.</div>".html_safe
    end
  end

  def user_battles_in_progress_list
    viewing = User.find(params["id"])
    battle_list = ""
    for b in viewing.protag_battles.in_progress do
      protag = Character.find(b.protag_id)
      antag = Character.find(b.antag_id)
      battle_list += "<a href='/battles/#{b.id}' class='bip_link'>#{protag.supername} vs. #{antag.supername}</a>"
    end

    return battle_list
  end

end

