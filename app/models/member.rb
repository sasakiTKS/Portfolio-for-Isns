class Member < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  validates :name, presence: true

  has_many :relationships, foreign_key: :follower_id
  has_many :followers, through: :relationships, source: :followed
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :followed_id
  has_many :follows, through: :reverse_of_relationships, source: :follower
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  def self.guest
    find_or_create_by!(name: 'guestmember', email: 'guest@example.com') do |member|
      member.password = SecureRandom.urlsafe_base64
      member.name = "guestmember"
    end
  end

  def self.looks(search, word)
    if search == "perfect_matuch"
      @member = Member.where("name LIKE? ", "#{word}")
    elsif search == "forward_match"
      @member = Member.where("name LIKE? ", "%#{word}")
    elsif search == "backward_match"
      @member = Member.where("name LIKE? ", "#{word}%")
    elsif search == "partial_match"
      @member = Member.where("name LIKE? ", "%#{word}%")
    else
      @member = Member.all
    end
  end

  def get_profile_image
    if profile_image.attached?
      profile_image
    else
      'no_image.jpg'
    end
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def active_for_authentication?
    super && (is_deleted == false)
  end

  def is_followed_by?(member)
    reverse_of_relationships.find_by(follower_id: member.id).present?
  end

end
