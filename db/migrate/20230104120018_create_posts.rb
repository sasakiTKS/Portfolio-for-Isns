class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|

      t.integer :member_id
      t.string :title
      t.string :detail
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
