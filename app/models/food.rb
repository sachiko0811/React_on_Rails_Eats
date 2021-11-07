# --- ここから追加 ---
class Food < ApplicationRecord
  belongs_to :restaurant
  belongs_to :order, optional: true
  has_one :line_food #FoodはLineFoodモデルとは1:1の関係
end
# --- ここまで追加 ---
