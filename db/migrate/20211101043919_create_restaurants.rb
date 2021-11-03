class CreateRestaurants < ActiveRecord::Migration[6.0] #  作成するCreateテーブル名:  テーブル名はrestaurants 
  def change
    create_table :restaurants do |t| #create_table : テーブル名
      # --- ここから追加 ---
      t.string :name, null: false
      t.integer :fee, null: false, default: 0
      t.integer :time_required, null: false

      t.timestamps
      # --- ここまで追加 ---
    end
  end
end

# 店舗データのMigration file