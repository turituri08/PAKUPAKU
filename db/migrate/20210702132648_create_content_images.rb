# frozen_string_literal: true

class CreateContentImages < ActiveRecord::Migration[5.2]
  def change
    create_table :content_images do |t|
      t.integer  :content_id, null: false
      t.string   :image_id

      t.timestamps
    end
  end
end
