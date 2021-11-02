class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      # --- ここから追加 ---
      t.integer :total_price, null: false, default: 0

      t.timestamps
      # --- ここまで追加 ---
    end
  end
end
