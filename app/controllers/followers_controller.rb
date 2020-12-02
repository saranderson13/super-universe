class FollowersController < ApplicationController

    def create
        user = User.find(follow_params[:user_id])
        @new_follow = user.followers.new(following: follow_params[:following])

        if @new_follow.valid?
            @new_follow.save
            flash[:notice] = "You are now following #{user.alias}."
        elsif !@new_follow.errors.messages[:following].empty?
            flash[:notice] = @new_follower.errors.messages[:following][0]
        else
            flash[:notice] = "There has been an error."
        end

        redirect_to user_path(user)
    end

    
    def destroy

        @follow = Follower.find_by(user_id: follow_params[:user_id], following: follow_params[:following])
        user = User.find(@follow.user_id)
        
        @follow.destroy
        flash[:notice] = "You have unfollowed #{user.alias}."
        redirect_to user_path(user)

    end


    private

    def follow_params
        params.permit(:user_id, :following)
    end
  
  end