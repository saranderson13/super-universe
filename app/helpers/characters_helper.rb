module CharactersHelper

  # On Char Show Pg - shows edit/delete char links if char belongs to current user (or if current user is admin)
  def char_edit_links
    render 'layouts/char_edit_links' if logged_in? && (current_user.id == params[:user_id].to_i || current_user.admin_status)
  end

  # On Char Show Pg - controls whether :secret_identity is shown or redacted.
  def secret_id_class
    if @secret_id == "REDACTED"
      redacted = "<span class='redacted'>#{@secret_id}</span>"
      redacted.html_safe
    else
      revealed = "<span class='revealed'>#{@secret_id}</span>"
      revealed.html_safe
    end
  end

  def dox_code_instruction(form)
    if form == "edit"
      "When editing your Dox Code, keep the following things in mind. LEAVING THE FIELD BLANK will leave your dox code unchanged. ENTERING A HYPHEN ('-' without the quotation marks) will erase your current dox code, and upon returning to your character page, their secret identity will be revealed. ENTERING A NEW DOX CODE will change your dox code."
    elsif form == "new"
      "Dox Codes are optional. By default (if you don't set one) your character's secret identity will be revealed on the character page. If you set one, it will be REDACTED."
    end
  end

  # Used to place error messages in the new/edit char forms.
  def char_form_error(field)
    case field
    when :supername
      "!! Must have a supername." if !@char.errors[:supername].empty?
    when :secret_identity
      "!! Must have a secret identity." if !@char.errors[:secret_identity].empty?
    when :char_type
      "!! Please choose a character type." if !@char.errors[:char_type].empty?
    when :alignment
      "!! #{@char.errors[:alignment][0]}" if !@char.errors[:alignment].empty?
    when :hp
      "!! #{@char.errors[:hp][0]}" if !@char.errors[:hp].empty?
    when :bio
      "!! Bio is too long - max length: 500 characters." if !@char.errors[:bio].empty?
    end
  end

  def char_showpg_superpowers
    char = Character.find_by(id: params[:id])
    if char.powers.count == 0
      msg = "<div class='char_showpg_no_powers_msg'>This character has no powers! Why not go add some?<br><span class='char_showpg_button black'><a href='/powers'>Go Browse the Superpowers</a></span></div>"
      msg.html_safe
    else
      render partial: 'char_showpg_powers'
    end
  end

  def char_showpg_delpwr(p)
    if logged_in? && current_user.id == params[:user_id].to_i || current_user.admin_status?
      render partial: 'char_showpg_delete', locals: { power: p }
    end
  end

end