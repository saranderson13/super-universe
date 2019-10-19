class CharactersController < ApplicationController

  def new
    authorized_to_edit_char?
    @user = set_user
    @char = Character.new()
    @alignments = Character.all_alignments
  end

  def create
    authorized_to_edit_char?
    @user = set_user
    @char = @user.characters.build(char_params)
    binding.pry
    if @char.valid?
      @char.save
      redirect_to user_character_path(id: @char.id, user_id: @char.user_id)
    else
      @alignments = Character.all_alignments
      render :new
    end
  end

  def show
    @user = set_user
    @char = set_char
    @secret_id = @char.dox("") if char_security_checks

  end

  def edit
    authorized_to_edit_char?
    @user = set_user
    @char = set_char
    @alignments = Character.all_alignments
  end

  def update
    authorized_to_edit_char?
    @user = set_user
    @char = set_char
    @alignments = Character.all_alignments

    # Determine if :dox_code should be updated - if field blank, do not update.
    params[:user][:character][:dox_code] == "" ? @char.update_attributes(char_params_no_dox_set) : @char.update_attributes(char_params)

    if @char.valid?
      @char.save
      redirect_to user_character_path(id: @char.id, user_id: @char.user_id)
    else
      render :edit
    end
  end

  def destroy
    authorized_to_edit_char?
    @user = set_user
    @char = set_char
    flash[:notice] = "CONFIRMATION: #{@char.supername.upcase} HAS BEEN DELETED"
    @char.destroy
    redirect_to user_path(@user)
  end



  def dox
    @char = set_char
  end

  def dox_char
    @char = set_char
    if @char.dox(dox_params[:dox_code]) != "REDACTED"
      @char.dox_code = "-"
      @char.save
      flash[:notice] = "Congratulations! You have successfully doxed #{@char.supername}."
      redirect_to user_character_path(id: @char.id, user_id: @char.user_id)
    else # Guess was incorrect
      flash[:notice] = "You have failed to dox #{@char.supername}. Try again."
      redirect_to user_character_path(id: @char.id, user_id: @char.user_id)
    end
  end


  private

  def char_security_checks
    if @user.nil?
      flash[:notice] = "warning: that user does not exist."
      redirect_to root_path and return
    elsif @char.nil?
      flash[:notice] = "warning: that character does not exist."
      redirect_to user_path(@user) and return
    elsif @char.user_id != @user.id
      flash[:notice] = "warning: that character does not belong to the specified user."
      redirect_to user_path(@user) and return
    else
      return true
    end
  end

  def set_user
    User.find_by(id: params[:user_id])
  end

  def set_char
    Character.find_by(id: params[:id])
  end

  def char_params
    params.require(:user).require(:character).permit(:supername, :secret_identity, :dox_code, :char_type, :alignment, :hp, :att, :def, :bio)
  end

  def char_params_no_dox_set
    params.require(:user).require(:character).permit(:supername, :secret_identity, :char_type, :alignment, :hp, :att, :def, :bio)
  end

  def dox_params
    params.permit(:dox_code, :id)
  end
end
