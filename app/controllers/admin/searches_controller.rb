class Admin::SearchesController < ApplicationController

  def search
     @range = params[:range]
    if @range == "メンバー名"
      @members = Member.looks(params[:search], params[:word])
    else
      @comments = Comment.looks(params[:search], params[:word])
    end
  end

end
