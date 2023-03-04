class Public::MembersController < ApplicationController
  before_action :authenticate_member!
  before_action :guest_check

  def guest_check
    if current_member == Member.find(1) #ID1はゲストメンバー
      redirect_to root_path,notice: "会員登録が必要です。"
    end
  end

  def mypage
    @member = current_member
    @posts = Post.where(member_id: current_member.id, status: 0).includes(:member).order("created_at DESC").page(params[:page]).per(6)
  end

  def show
    @member = Member.find(params[:id])
    @posts = Post.where(member_id:params[:id]).page(params[:page]).per(6)
  end

  def edit
    @member = current_member
  end

  def update
    @member = Member.find(params[:id])
    @member.update
  end

  def likes
    likes = Like.where(member_id: current_member.id).pluck(:post_id)
    @like_posts = Post.find(likes)
  end

  def confirm
    @member = current_member
    @posts = @member.posts.where(status: 1).order('created_at DESC').page(params[:page]).per(6)
  end

  def withdraw
    @member = current_member
    @member.update(is_deleted: true)
    reset_session
    flash[:danger] = "退会処理いたしました"
    redirect_to new_member_registration_path
  end

  def followers
    @member = Member.find(params[:id])
    @members = @member.followers
  end

  def follows
    @member = Member.find(params[:id])
    @members = @member.follows
  end

end
