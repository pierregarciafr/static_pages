class RelationshipsController < ApplicationController

  before_action :find_user, only: [:create, :delete]

    def create
    relationship = current_user.active_relationships.build(followed_id: @user.id)
    if relationship.save
      flash[:success] = 'Following this user now !'
      redirect_to user_path(@user)
    else
      flash[:danger] = 'Follow aborted'
      render 'users/show'
    end
  end

  def destroy
    relationship = Relationship.find(params[:id])
    user = User.find(relationship.followed_id)
    if relationship.destroy
      flash[:success] = 'User cancelled from following.'
      redirect_to user_path(user)
    else
      flah[:danger] = 'Unfollow aborted.'
      render 'users/show'
    end
  end

  private

  def find_user
    @user = User.find(params[:followed_id])
  end
end
