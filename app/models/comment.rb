class Comment < ApplicationRecord

  has_many :notifications, dependent: :destroy

  belongs_to :member

  belongs_to :post

  validates :comment, presence: true

  def self.looks(search, word)
    if search == "perfect_matuch"
      @comment = Comment.where("comment LIKE?", "#{word}")
    elsif search == "forward_match"
      @comment = Comment.where("comment LIKE?", "#{word}%")
    elsif search == "backward_match"
      @comment = Comment.where("comment LIKE?", "%#{word}")
    elsif search == "partial_match"
      @comment = Comment.where("comment LIKE?", "%#{word}%")
    else
      @comment = Comment.all
    end
  end
end
