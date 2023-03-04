class Admin::MembersController < ApplicationController
  def index
    @members = Member.page(params[:page]).per(10)
  end

  def show
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      flash[:success] = "更新成功しました"
      redirect_to admin_member_path
    else
      flash[:danger] = "更新失敗しました"
      render :show
    end
  end

  private

  def member_params
    params.require(:member).permit(:is_deleted)
  end

end
