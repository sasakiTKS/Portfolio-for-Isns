class Like < ApplicationRecord

  belongs_to :member
  belongs_to :post
  validates_uniqueness_of :post_id, scope: :member_id
end
