class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id,    null: false
      t.integer :content_id, null: false

      t.timestamps
    end
  end
  
end
