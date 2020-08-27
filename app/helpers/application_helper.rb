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

  def admin_links
    if logged_in? && current_user.admin_status
      link = "<a href='/users'>Users</a>"
      link.html_safe
    end
  end

  def add_to_char_or_login
    if !logged_in?
      msg = "<div class='pwr_form_msg'>Please <span class='pwr_form_link short'><a href='/signup'>sign up</a></span> or <span class='pwr_form_link short'><a href='/login'>log in</a></span> to add this power to a character.</div>"
      msg.html_safe
    elsif logged_in? && current_user.characters.count == 0
      msg = "<div class='pwr_form_msg'>You do not currently have any characters. <span class='pwr_form_link long'><a href='/users/#{current_user.id}/characters/new'>Create a Character</a></span> if you would like to add this move.</div>"
      msg.html_safe
    elsif characters_for_add_power.empty?
      msg = "<div class='pwr_form_msg'> This power is not available for any of your characters - either it has already been assigned, or their power capacity is full.</div>"
      msg.html_safe
    else
      render 'powers/add_power_form'
    end
  end

  def break_the_lines(text)
    text.to_s.gsub(/\n/, '<br/>').html_safe
  end

  def battle_result_for_welcome(battle)
    protag = Character.find_by(id: battle.protag_id)
    antag = Character.find_by(id: battle.antag_id)
    if battle.outcome == "Victory"
      "#{battle.protag.supername} was victorious against #{battle.antag.supername}!"
    else
      "#{battle.protag.supername} was defeated by #{battle.antag.supername}!"
    end
  end

  def leader_board_char(c, i)
    ("<div class='leader_entry'>#{i + 1}. #{c.supername}</div>").html_safe
  end

  def welcome_pg_if_not_logged_in
    if !logged_in?
      content = '<h3 class="welcome_subheading"><a href = "/login">Log in</a> or <a href="/signup">Sign up</a> to join the battle!</h3>'
      content.html_safe
    end
  end

end
