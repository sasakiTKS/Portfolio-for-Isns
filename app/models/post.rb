class Post < ApplicationRecord

  belongs_to :member
  has_many :notifications, dependent: :destroy
  has_many :tag_posts, dependent: :destroy
  has_many :tags, through: :tag_posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_members, through: :likes, source: :member

  has_one_attached :post_image

  enum status:{released: 0, nonreleased: 1}

  validates :title, presence: true
  validates :detail, length: { minimum: 2 }

  scope :latest, -> {order(updated_at: :desc)}
  scope :old, -> {order(updated_at: :asc)}
  scope :like_count, -> { includes(:likes).sort {|a,b| b.likes.size <=> a.likes.size}}

  def get_post_image
    if post_image.attached?
      post_image
    end
  end

  def self.looks(search, word)
    if search == "perfect_matuch"
      @post = Post.where("title LIKE? OR detail LIKE?", "#{word}", "#{word}")

    elsif search == "forward_match"
      @post = Post.where("title LIKE? OR detail LIKE?", "%#{word}", "%#{word}")

    elsif search == "backward_match"
      @post = Post.where("title LIKE? OR detail LIKE?", "#{word}%", "#{word}%")

    elsif search == "partial_match"
      @post = Post.where("title LIKE? OR detail LIKE?", "%#{word}%", "%#{word}%")

    else
      @post = Post.all
    end
  end

  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'old'
      return all.order(created_at: :ASC)
    when 'likes'
      return find(Like.group(:post_id).order(Arel.sql('count(post_id) desc')).pluck(:post_id))
    when 'dislikes'
      return find(Like.group(:post_id).order(Arel.sql('count(post_id) asc')).pluck(:post_id))
    end
  end

  def liked_by?(member)
    likes.where(member_id: member.id).exists?
  end

  def tags_save(tag_list)
    if self.tags != nil
      tag_posts_records = TagPost.where(post_id: self.id)
      tag_posts_records.destroy_all
    end

    tag_list.each do |tag|
      inspected_tags = Tag.where(name: tag).first_or_create
      self.tags << inspected_tags
    end

  end

  def create_notification_like!(current_member)
      temp = Notification.where(["visiter_id = ? and visited_id = ? and post_id = ? and action = ? ", current_member.id, member_id, id, "like"])
      if temp.blank?
        notification = current_member.active_notifications.new(
          post_id: id,
          visited_id: member_id,
          action: "like"
        )
        if notification.visiter_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
      end
  end

  def create_notification_comment!(current_member, comment_id)
      notification = Notification.new
      notification.visited_id = self.member_id
      notification.visiter_id = current_member.id
      notification.action = "comment"
      notification.comment_id = comment_id
      notification.post_id = self.id
      notification.save
  end

end
