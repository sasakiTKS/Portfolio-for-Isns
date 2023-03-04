module Public::NotificationsHelper

  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    your_post = link_to 'あなたの投稿', post_path(notification), style: "font-weight: bold"
    @visiter_comment = notification.comment_id

    case notification.action
      when "like" then
        tag.a(@visiter.name, href:member_path(notification.visiter_id))+"が"+tag.a(notification.post.title, href:post_path(notification.post_id))+"にいいねしました"
      when "comment" then
        @comment = Comment.find_by(id: @visiter_comment)&.comment
        tag.a(@visiter.name, href:member_path(notification.visiter_id))+"が"+tag.a(notification.post.title, href:post_path(notification.post_id))+"にコメントをしました"
    end
  end

  def unchecked_notifications
    @notifications = current_member.passive_notifications.where(checked: false)
  end

end
