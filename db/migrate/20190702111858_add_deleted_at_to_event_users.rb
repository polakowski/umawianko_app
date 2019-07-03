class AddDeletedAtToEventUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :event_users, :deleted_at, :datetime
    add_index :event_users, :deleted_at
  end
end
