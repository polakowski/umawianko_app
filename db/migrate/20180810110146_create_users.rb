# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def self.up
    create_table :users do |t|
      t.string :uid,                null: false
      t.string :email,              null: false
      t.string :name
      t.string :image

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :uid,                  unique: true
  end

  def self.down
    drop_table :users
  end
end
