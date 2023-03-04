class ChangeColumnDefaultToNotifications < ActiveRecord::Migration[6.1]
  def change
    change_column_default :notifications, :action, from: nil, to: ""
  end
end
