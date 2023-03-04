class Public::SearchesController < ApplicationController
  before_action :authenticate_member!

  def search
    @posts = Post.looks(params[:search], params[:word])
    @tag_list = Tag.all
  end

end
