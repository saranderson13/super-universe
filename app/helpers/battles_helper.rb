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
    if @battle.outcome == "Victory" && @protag.char_type == "Hero" || @battle.outcome == "Defeat" && @antag.char_type == "Hero"
      tag = "<div id='results_pg_wrapper' class='white'>"
    else
      tag = "<div id='results_pg_wrapper' class='black'>"
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
      msg = @protag.char_type == "Hero" ? "<div class='battle_log white'>" : "<div class='battle_log black'>"
    else
      msg = @protag.char_type == "Hero" ? "<div class='battle_results white'>" : "<div class='battle_results black'>"
    end
    msg.html_safe
  end

  def att_button_color
    msg = '<span class="black">' if @protag.char_type == "Hero"
    msg = '<span class="white">' if @protag.char_type == "Villain"
    msg.html_safe
  end


  def style_log_text_in_prog(text)
    counter = 0
    turn, log = "", ""
    lines = text.split('*')

    lines.each_with_index do |l, i|
      if counter == 0
        turn_icon = l[1..-1].to_i.odd? ? "<div class='turn_icon'>▶ " : "<div class='turn_icon antag_turn'>◀ "
        turn_icon += l[0] == "H" ? "<img src='/assets/attack_hit.png' class='hit'></div>" : "<img src='/assets/attack_miss.png' class='miss'></div>"

        turn = "<div class='player_turn'>#{turn_icon}"
        counter += 1
      elsif counter == 1
        turn += "<div><div class = 'turn_action'>#{l}</div>"
        counter += 1
      elsif counter == 2
        turn += "<div class='turn_description'>#{l}</div>"
        counter += 1
      else 
        turn += "<div class='turn_outcome'>#{l}</div></div></div>"
        counter = 0
        log += turn
        turn = ""
      end
    end

    log.html_safe
  end


  def style_log_text_battle_complete(text)

    counter = 0
    turn, log = "", ""
    lines = text.split('*')

    if lines[0] == "V"
      log = <<~HEREDOC
      <div class="results_summary">
        <div>
          <div class="player_points">#{lines[1]}</div>
      HEREDOC
      if lines[2] == "LU"
        log += "<div class='player_lvlup'>#{lines[3]}</div><div class='player_next_lvl'>#{lines[4]}</div></div></div>"
        lines.shift(5)
      else
        log += "<div class='player_lvlup'>#{lines[2]}</<div></div></div>"
        lines.shift(3)
      end
    end

    log += style_log_text_in_prog(lines.join("*"))


    log.html_safe
  end


  def outcome_declaration 
    @battle.outcome == "Victory" ? "#{@protag.supername} was victorious!" : "#{@protag.supername} was defeated"
  end

  
  def move_line_styling(move, battle)
    if move.move_type == "pwr" && !!battle.p_used_pwrmv
      tag = battle.protag.char_type == "Hero" ? "<div class='battle_pg_move pwrmv_used_hero'>" : "<div class='battle_pg_move pwrmv_used_villain'>"
    else
      tag = "<div class='battle_pg_move'>"
    end
    tag.html_safe
  end




end
