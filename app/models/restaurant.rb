# --- ここから追加 ---
class Restaurant < ApplicationRecord
  has_many :foods
  has_many :line_foods, through: :foods

  validates :name, :fee, :time_required, presence: true
  validates :name, length: { maximum: 30 } #nameが最大30文字以下
  validates :fee, numericality: { greater_than: 0 } #配送手数料
end
# --- ここまで追加 ---

# ここではバリデーション定義。
# バリデーション: そのカラムのデータに対して制限を設けること