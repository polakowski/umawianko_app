class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :place
      t.datetime :datetime
      t.integer :creator_id
    end
  end
end
