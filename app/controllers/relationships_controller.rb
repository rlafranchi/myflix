class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if current_user.following_relationships.include?(relationship)
    redirect_to people_path
  end

  def create
    leader = User.find(leader_params[:leader_id])
    Relationship.create(leader: leader, follower: current_user) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  private

  def leader_params
    params.require(:relationship).permit!
  end
end
