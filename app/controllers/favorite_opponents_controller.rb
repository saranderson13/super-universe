class FavoriteOpponentsController < ApplicationController

    def create
        char = Character.find(fave_params.character_id)
        @new_fave = current_user.favorite_opponents.new(character_id: char.id)

        if @new_fave.valid?
            @new_fave.save
            flash[:notice] = "You have favorited #{char.supername}."
        else
            flash[:notice] = "There has been an error."
        end

        redirect_to user_character_path(user_id: char.user_id, id: char.id)
    end


    def destroy

        char = Character.find(fave_params.character_id)
        @fave_entry = FavoriteOpponent.find_by(user_id: fave_params.user_id, character_id: char.id)

        if fave_params.user_id == current_user.id
            @fave_entry.destroy
            flash[:notice] = "You have unfavorited #{char.supername}."
        else
            flash[:notice] = "There has been an error."
        end

        redirect_to user_character_path(user_id: char.user_id, id: char.id)
    end


    private

    def fave_params
        params.permit(:user_id, :character_id)
    end

end