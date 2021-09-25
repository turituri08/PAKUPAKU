class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string   :ingredient, null: false

      t.timestamps
    end
  end
end
