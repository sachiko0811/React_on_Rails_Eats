# --- ここから追加 ---
class Order < ApplicationRecord
  has_many :line_foods

  validates :total_price, numericality: { greater_than: 0 }

  def save_with_update_line_foods!(line_foods) #LineFoodデータの更新と、Orderデータの保存を処理
    ActiveRecord::Base.transaction do
      line_foods.each do |line_food| #一つずつブロック内の処理を実行 -> update_attributes!(...)でattributesを更新
        line_food.update_attributes!(active: false, order: self)
      end
      self.save!
    end
  end
end
# --- ここまで追加 ---

# ActiveRecord::Base.transaction do ...(トランザクション内の処理) end

## 破壊的メソッド -> update_attributes!やsave!を使ってはじめて失敗時に例外をキャッチしてロールバックを行う
# ここではline_food.update_attributes!とself.save!の２つの処理に対してトランザクションを張っていることがわかる。どちらか片方でも失敗した場合にこのsave_with_update_line_foods!は失敗となり、ロールバックしてくれる