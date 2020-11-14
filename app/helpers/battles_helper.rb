module BattlesHelper

  def battle_pg_wrapper_set_bg(char)
    if char.char_type == "Hero"
      tag = "<div id='battle_pg_wrapper' class='black'>"
    else
      tag = "<div id='battle_pg_wrapper' class='white'>"
    end
    tag.html_safe
  end


  def battlepg_bg_styling(char, char_hp, opp_hp)
    w = (char_hp.to_f/(char_hp + opp_hp))*100
    if char.char_type == "Hero"
      tag = "<div id='battle_pg_hero_side' class='battle_pg_side' style='width: #{w}%'>"
    elsif char.char_type == "Villain"
      tag = "<div id='battle_pg_villain_side' class='battle_pg_side' style='width: #{w}%'>"
    end
    tag.html_safe
  end

  def resultpg_bg_styling
    if @battle.outcome == "Victory"
      if @protag.char_type == "Hero"
        tag = "<div id='battle_pg_hero_side' class='battle_pg_side' style='width: 100%'></div>"
      else
        tag = "<div id='battle_pg_villain_side' class='battle_pg_side' style='width: 100%'></div>"
      end
    else
      if @protag.char_type == "Hero"
        tag = "<div id='battle_pg_villain_side' class='battle_pg_side' style='width: 100%'></div>"
      else
        tag = "<div id='battle_pg_hero_side' class='battle_pg_side' style='width: 100%'></div>"
      end
    end
    tag.html_safe
  end

  def battle_title
    p_color = @protag.char_type == "Hero" ? "white" : "black"
    a_color = @antag.char_type == "Hero" ? "white" : "black"
    msg = <<~HEREDOC
      <span class='#{p_color} left_hp'>HP: #{@battle.p_hp}</span>
      <span class='#{p_color}'><a href="/users/#{@protag.user_id}/characters/#{@protag.id}">#{@protag.supername}</a></span>
       vs. 
      <span class='#{a_color}'><a href="/users/#{@antag.user_id}/characters/#{@antag.id}">#{@antag.supername}</a></span>
      <span class='#{a_color} right_hp'>HP: #{@battle.a_hp}</span>
    HEREDOC
    msg.html_safe
  end

  def protag_form_styling
    msg = @protag.char_type == "Hero" ? "<div class='protag_form white'>" : "<div class='protag_form black'>"
    msg.html_safe
  end

  def battle_log_styling
    if @battle.outcome == "Pending"
      msg = @protag.char_type == "Hero" ? "<div class='battle_log white battle_in_prog'>" : "<div class='battle_log black battle_in_prog'>"
    else
      msg = @protag.char_type == "Hero" ? "<div class='battle_log white battle_results'>" : "<div class='battle_log black battle_results'>"
    end
    msg.html_safe
  end

  def att_button_color
    msg = '<span class="black">' if @protag.char_type == "Hero"
    msg = '<span class="white">' if @protag.char_type == "Villain"
    msg.html_safe
  end


end
