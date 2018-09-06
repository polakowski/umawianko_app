class AddIconToEventType < ActiveRecord::Migration[5.1]
  def change
    add_column :event_types, :icon, :string
  end
end
