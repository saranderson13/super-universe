class PowersController < ApplicationController

  helper_method :characters_for_add_power

  def index
    @powers = Power.all
    @pe_pwrs = @powers.physical_enhancements
    @me_pwrs = @powers.mental_enhancements
    @em_pwrs = @powers.elemental_masteries
    @ma_pwrs = @powers.magical_abilities
  end

  def show
    @power = Power.find_by(id: params[:id])
    if !@power.nil?
      @att = @power.fetch_move("att")
      @pwr = @power.fetch_move("pwr")
      @characters = characters_for_add_power if (logged_in? && !current_user.nil?)
    else
      flash[:notice] = "Warning: That power does not exist."
      redirect_to powers_path
    end
  end

  def new
    if logged_in?
      @power = Power.new
      @power.moves.build(move_type: "att")
      @power.moves.build(move_type: "pwr")
      set_types
    else
      flash[:notice] = "You must be logged in to create powers."
      redirect_to root_path
    end
  end

  def create
    if logged_in?
      @power = Power.new(power_params)
      if @power.valid?
        @power.save
        redirect_to power_path(@power) and return
      else
        set_types
        @errors = @power.errors.full_messages
        render :new
      end
    end
  end

  def edit
    if logged_in?
    # I would consider making editing powers be an admin capability
    # If not a user_id column would need to be added to, and powers would only belong to one user.
    # if logged_in? && current_user.admin_status
      @power = Power.find_by(id: params[:id])
      set_types

      # This should never be necessary unless there's a db problem... but I added it as a fail safe.
      if @power.moves.empty?
        @power.moves.build(move_type: "att")
        @power.moves.build(move_type: "pwr")
      end
    end
  end

  def update
    if logged_in?
    # if logged_in? && current_user.admin_status
      @power = Power.find_by(id: params[:id])
      @power.update_attributes(power_params)
      if @power.valid?
        @power.replace_old_moves
        @power.save
        redirect_to power_path(@power) and return
      else
        set_types
        render :edit
      end
    end
  end

  private

  def set_types
    @types = Power.types
  end

  def characters_for_add_power
    pwr = Power.find(params[:id])
    current_user.characters.map { |c| c if (c.powers.count < 3 && !c.powers.include?(pwr)) }.compact
  end

  def power_params
    params.require(:power).permit(:name, :pwr_type, moves_attributes:[:name, :base_pts, :success_descrip, :fail_descrip, :move_type ])
  end

end
