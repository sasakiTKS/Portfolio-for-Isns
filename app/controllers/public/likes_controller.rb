class Public::LikesController < ApplicationController
  before_action :authenticate_member!
  before_action :guest_check

  def guest_check
    if current_member == Member.find(1) #ID1はゲストメンバー
      redirect_to root_path,notice: "会員登録が必要です。"
    end
  end

  def create
    @post = Post.find(params[:post_id])
    like = Like.new(member_id: current_member.id, post_id: params[:post_id])
    like.save
    @post.create_notification_like!(current_member)
    redirect_to request.referer
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = Like.find_by(member_id: current_member.id, post_id: params[:post_id])
    like.destroy
    redirect_to posts_path
  end

end
