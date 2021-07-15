# frozen_string_literal: true

class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.integer  :user_id,      null: false
      t.text     :body,         null: false
      t.string   :target_age,   null: false

      t.timestamps
    end
  end
end
