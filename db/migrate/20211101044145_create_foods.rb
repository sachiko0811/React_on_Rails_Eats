class CreateFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :foods do |t|
      # --- ここから追加 ---
      t.references :restaurant, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description, null: false

      t.timestamps
      # --- ここまで追加 ---
    end
  end
end
