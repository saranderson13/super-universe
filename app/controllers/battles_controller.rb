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
    if !@battle.nil? && authorized_to_battle?
      @protag = set_protag_on_show
      @antag = set_antag_on_show
      if @battle.outcome != "Pending"
        render 'battle_result' and return
      end
    else
      flash[:notice] = "warning: either that battle does not exist, or you are not authorized to view it."
      redirect_to root_path
    end
  end

  def update
    # binding.pry
    @battle = Battle.find_by(id: params[:id])
    if !@battle.nil? && authorized_to_battle?
      protag = Character.find_by(id: turn_params[:protag_id])
      antag = Character.find_by(id: turn_params[:antag_id])
      move = Move.find_by(id: turn_params[:attack])
      #PROTAG ATACK STAGE
        # increase turn count
        @battle.advance_turn
        # determine if the opponent dodged
        if antag.dodge?
          #add turn outcome to log
          @battle.log = @battle.turn_dialog(protag, move, antag, "miss")
        else
          # adjust hp of antagonist
          @battle.a_hp -= move.adjusted_pts(protag, antag)
          # add turn outcome to log
          @battle.log = @battle.turn_dialog(protag, move, antag, "hit")
        end
        # check for used_power_move?
        @battle.p_used_pwrmv = true if move.move_type == "pwr"
        @battle.save
        # check for win?
        if @battle.a_hp <= 0
          @battle.update(outcome: "Victory")
          @battle.log = @battle.end_of_battle_dialog
          @battle.save
          protag.victory_results(antag)
          redirect_to battle_path(@battle) and return
        else
        # ANTAG ATTACK STAGE
          # increase turn count
          @battle.advance_turn
          # generate antagonist move
          a_move = antag.antag_attack(@battle)
          # determine if protagonist dodged
          if protag.dodge?
            #add turn outcome to log
            @battle.log = @battle.turn_dialog(antag, move, protag, "miss")
          else
            # adjust hp of antagonist
            @battle.p_hp -= move.adjusted_pts(antag, protag)
            # add turn outcome to log
            @battle.log = @battle.turn_dialog(antag, move, protag, "hit")
          end
          # check for used_power_move?
          @battle.a_used_pwrmv = true if a_move.move_type == "pwr"
          # check for win?
          if @battle.p_hp <=0
            @battle.update(outcome: "Defeat")
            @battle.log = @battle.end_of_battle_dialog
            @battle.save
            protag.defeat_results
          end
          # redirect_to battles_path(@battle)
          @battle.save
          redirect_to battle_path(@battle) and return
        end
    else
      flash[:notice] = "warning: invalid battle action"
      redirect_to root_path
    end
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

  def turn_params
    params.permit(:id, :protag_id, :antag_id, :attack)
  end

  def authorized_to_battle?
    protag = set_protag_on_show
    current_user.id == protag.user_id
  end

end
