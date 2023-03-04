class Public::NotificationsController < ApplicationController
  before_action :authenticate_member!
  before_action :guest_check

  def guest_check
    if current_member == Member.find(1) #ID1はゲストメンバー
      redirect_to root_path,notice: "会員登録が必要です。"
    end
  end

  def index
    @notifications = current_member.passive_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy_all
    @notifications = current_member.passive_notifications.destroy_all
    redirect_to notifications_path
  end

end
