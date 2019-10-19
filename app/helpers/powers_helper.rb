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

end
