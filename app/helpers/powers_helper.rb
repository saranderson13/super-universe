module PowersHelper

# NOT SURE WHY POWERS VIEWS CAN'T ACCESS THIS...
# THIS METHODS IS NOW IN ApplicationHelper

  # def add_to_char_or_login
  # if !logged_in?
  #   msg = "<div class='pwr_form_msg'>Please <span class='pwr_form_link short'><a href='/signup'>sign up</a></span> or <span class='pwr_form_link short'><a href='/login'>log in</a></span> to add this power to a character.</div>"
  #   msg.html_safe
  # elsif logged_in? && current_user.characters.count == 0
  #   msg = "<div class='pwr_form_msg'>You do not currently have any characters. <span class='pwr_form_link long'><a href='/users/#{current_user.id}/characters/new'>Create a Character</a></span> if you would like to add this move.</div>"
  #   msg.html_safe
  # elsif characters_for_add_power.empty?
  #   msg = "<div class='pwr_form_msg'> This power is not available for any of your characters - either it has already been assigned, or their power capacity is full.</div>"
  #   msg.html_safe
  # else
  #   render 'powers/add_power_form'
  # end
  # end

  def set_move_type(move)
    move.object.move_type == "att" ? "att" : "pwr"
  end

  def move_name_label(move)
    move.object.move_type == "att" ? "Common Attack Name" : "Power Attack Name"
  end

  def base_pts_options(move)
    move.object.move_type == "att" ? [15, 20, 25] : [45, 50, 55, 60]
  end

  def s_value_if_edit(form)
    "value='ex: was launched through the air from the force of the punch!'" if form == "new"
  end

end
