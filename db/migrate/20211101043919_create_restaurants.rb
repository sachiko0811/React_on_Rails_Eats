class CreateRestaurants < ActiveRecord::Migration[6.0] #  作成するCreateテーブル名:  テーブル名はrestaurants 
  def change
    create_table :restaurants do |t| #create_table : テーブル名
      # --- ここから追加 ---
      t.string :name, null: false # t.テーブルのカラム型 :カラム名, オプション... → 一番初めはstring型のnameというカラムを作成し、オプションとしてnullにはできないようにする
      t.integer :fee, null: false, default: 0 
      t.integer :time_required, null: false

      t.timestamps #　これはMigrationファイルに含まれているもので、自動的にcreated_at, updated_atの２つのカラムを作成してくれる
      # --- ここまで追加 ---
    end
  end
end

# 店舗データのMigration file