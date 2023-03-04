class Admin::CommentsController < ApplicationController

  def comments
    @comments = Comment.page(params[:page]).per(10)
  end

  def destroy
    @comments = Comment.all
    comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    if comment.destroy
     flash.now[:danger] = "コメントを削除しました"
     redirect_to request.referer
    end
  end
end
