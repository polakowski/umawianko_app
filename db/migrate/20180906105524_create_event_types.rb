class CreateEventTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :event_types do |t|
      t.string :name
      t.string :slack_webhook
      t.string :color

      t.timestamps null: false
    end
  end
end
