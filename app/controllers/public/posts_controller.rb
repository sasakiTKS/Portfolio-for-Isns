class Public::PostsController < ApplicationController
  before_action :authenticate_member!
  before_action :correct_post, only: [:edit]
  before_action :guest_check, only: [:new, :edit, :show, :create, :update, :destroy]

  def guest_check
    if current_member == Member.find(1) #ID1はゲストメンバー
      redirect_to root_path,notice: "会員登録が必要です。"
    end
  end

  def new
    @post = Post.new
    @post.tag_posts.build
  end

  def index
    @tag_list = Tag.all
    @posts = Post.where(status: :released).page(params[:page]).per(8)
    if params[:new]
      @posts = Post.where(status: :released).latest.page(params[:page]).per(8)
    elsif params[:old]
      @posts = Post.where(status: :released).old.page(params[:page]).per(8)
    elsif params[:like]
      posts = Post.where(status: :released).like_count
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(8)
    end
  end

  def show
    @post = Post.find(params[:id])
    @tag_posts = @post.tags
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(10)
    @member = current_member
    @member = @post.member
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def create
    @post = Post.new(post_params)
    @post.member_id = current_member.id
    tag_list = params[:post][:name].split(",")

    if tag_list == []
      tag = Tag.new()
      tag.name = ""
      tag.save
      @member = current_member
      flash[:danger] = "投稿に失敗しました"
      render :new
    elsif @post.save
      @post.tags_save(tag_list)
      flash[:success] = "投稿されました"
      redirect_to posts_path
    else
      @member = current_member
      flash[:danger] = "投稿に失敗しました"
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')

    if tag_list == []
      tag = Tag.new()
      tag.name = ""
      tag.save
      @member = current_member
      flash[:danger] = "更新に失敗しました"
      render :edit
    elsif @post.update(post_params)
      @post.tags_save(tag_list)
      flash[:success] = "更新されました"
      redirect_to post_path(@post.id)
    else
      @member = current_member
      flash[:danger] = "更新に失敗しました"
      render :edit
    end

  end

  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.where(status: :released)
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path, danger: '削除しました'
    else
      render :edit
    end
  end

  def correct_post
    @post = Post.find(params[:id])
    unless @post.member.id == current_member.id
      redirect_to posts_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :detail, :post_image, :status, {tag_ids: []}).merge(member_id: current_member.id)
  end

end
