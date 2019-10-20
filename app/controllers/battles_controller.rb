class BattlesController < ApplicationController

  def create
    protag = Character.find_by(id: battle_params[:protag_id])
    antag = Character.find_by(id: battle_params[:antag_id])
    if protag.protag_battle_ready?(antag) && antag.has_superpowers?
      b = Battle.create(battle_params)
      b.p_hp, b.a_hp = protag.hp, antag.hp
      b.save
      redirect_to battle_path(b) and return
    else
      flash[:notice] = "WARNING: INVALID BATTLE REQUEST"
      redirect_to user_character_path(user_id: antag.user_id, id: antag.id)
    end

  end

  def show
    @battle = set_battle
    if !@battle.nil?
      @protag = set_protag_on_show
      @antag = set_antag_on_show
    else
      flash[:notice] = "warning: that battle does not exist"
      redirect_to root_path
    end
  end

  def update
    binding.pry
  end

  private

  def set_battle
    Battle.find_by(id: params[:id])
  end

  def set_protag_on_show
    Character.find_by(id: @battle.protag_id)
  end

  def set_antag_on_show
    Character.find_by(id: @battle.antag_id)
  end

  def battle_params
    params.permit(:antag_id, :protag_id)
  end

end
