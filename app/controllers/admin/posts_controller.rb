class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @tag_list = Tag.all
    @posts = Post.where(status: :released).page(params[:page]).per(9)
    if params[:new]
      @posts = Post.latest.page(params[:page]).per(9)
    elsif params[:old]
      @posts = Post.old.page(params[:page]).per(9)
    elsif params[:like]
      posts = Post.like_count
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(9)
    end
  end

  def show
    @post = Post.find(params[:id])
    @tag_posts = @post.tags
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(10)
  end

  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path, danger: '削除しました'
    else
      render :edit
    end
  end

end
