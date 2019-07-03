class AddSignOffCountToEventUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :event_users, :sign_off_count, :integer, null: false, default: 0
  end
end
