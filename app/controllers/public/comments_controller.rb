class Public::CommentsController < ApplicationController
  before_action :authenticate_member!
  before_action :guest_check

  def guest_check
    if current_member == Member.find(1) #ID1はゲストメンバー
      redirect_to root_path,notice: "会員登録が必要です。"
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = current_member.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      flash.now[:success] = "コメントを投稿しました"
      @post.create_notification_comment!(current_member, @comment.id)
      redirect_to request.referer
    else
      flash.now[:danger] = "コメント投稿に失敗しました"
      redirect_to request.referer
    end

  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    if @comment.destroy
     flash.now[:danger] = "コメントを削除しました"
     redirect_to request.referer
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
