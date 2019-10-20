module BattlesHelper

  def battlepg_bg_styling(char, char_hp, opp_hp)
    w = (char_hp.to_f/(char_hp + opp_hp))*100
    if char.char_type == "Hero"
      tag = "<div id='battle_pg_hero_side' class='battle_pg_side' style='width: #{w}%'>"
      tag.html_safe
    elsif char.char_type == "Villain"
      tag = "<div id='battle_pg_villain_side' class='battle_pg_side' style='width: #{w}%'>"
      tag.html_safe
    end
  end

  def battle_title
    p_color = @protag.char_type == "Hero" ? "white" : "black"
    a_color = @antag.char_type == "Hero" ? "white" : "black"
    msg = "<span class='#{p_color} left_hp'>HP: #{@battle.p_hp}</span><span class='#{p_color}'>#{@protag.supername}</span> vs. <span class='#{a_color}'>#{@antag.supername}</span><span class='#{a_color} right_hp'>HP: #{@battle.a_hp}</span>"
    msg.html_safe
  end

  def protag_form_styling
    msg = @protag.char_type == "Hero" ? "<div class='protag_form white'>" : "<div class='protag_form black'>"
    msg.html_safe
  end

  def battle_log_styling
    msg = @protag.char_type == "Hero" ? "<div class='battle_log white'>" : "<div class='battle_log black'>"
    msg.html_safe
  end

  def protag_attacks
    attacks = []
    @protag.powers.each do |p|
      p.moves.each do |m|
        attacks << m if m.move_type == "att"
        attacks << m if m.move_type == "pwr" unless @battle.p_used_pwrmv == true
      end
    end
    attacks
  end

  def att_button_color
    msg = '<span class="black">' if @protag.char_type == "Hero"
    msg = '<span class="white">' if @protag.char_type == "Villain"
    msg.html_safe
  end



end
