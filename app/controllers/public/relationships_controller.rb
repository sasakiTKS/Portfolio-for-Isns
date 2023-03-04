class Public::RelationshipsController < ApplicationController
  before_action :authenticate_member!

  def create
    @follower = current_member.relationships.build(followed_id: params[:member_id])
    @follower.save
    redirect_to request.referrer || root_path
  end

  def destroy
    @follower = current_member.relationships.find_by(followed_id: params[:member_id])
    @follower.destroy
    redirect_to request.referrer || root_path
  end

end
