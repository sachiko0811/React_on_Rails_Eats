class CreateLineFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :line_foods do |t|
      # --- ここから追加 ---
      t.references :food, null: false, foreign_key: true #外部キー(モデル間のリレーションを辿る際の基準となるキー)を定義
      t.references :restaurant, null: false, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :count, null: false, default: 0
      t.boolean :active, null: false, default: false

      t.timestamps
      # --- ここまで追加 ---
    end
  end
end
