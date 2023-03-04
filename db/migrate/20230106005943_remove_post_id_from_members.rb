class RemovePostIdFromMembers < ActiveRecord::Migration[6.1]
  def change
    remove_column :members, :post_id, :integer
  end
end
