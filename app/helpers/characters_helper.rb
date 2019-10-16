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

    end
  end

end
