# --- ここから追加 ---
module Api
  module V1
    class OrdersController < ApplicationController
      def create
        posted_line_foods = LineFood.where(id: params[:line_food_ids])
        order = Order.new(
          total_price: total_price(posted_line_foods),
        )
        if order.save_with_update_line_foods!(posted_line_foods)
          render json: {}, status: :no_content
        else
          render json: {}, status: :internal_server_error
        end
      end

      private

      def total_price(posted_line_foods)
        posted_line_foods.sum {|line_food| line_food.total_amount } + posted_line_foods.first.restaurant.fee
      end
    end
  end
end
# --- ここまで追加 ---

## LineFoodの更新とOrderの作成を処理
# 複数の仮注文があるため複数のidの配列がパラメーターとしてフロントから送られる
# ->  ex. [1,2,3] -> これらをLineFood.whereに渡すことで対象のidのデータを取得し、posted_line_foodsという変数に代入 -> それらを合算し一つのOrder.newし、orderインスタンスを生成

## トランザクション ##
# トランザクション内にある１つ以上の処理の中で１つでも失敗したら、処理をロールバック(やり直し)させたい場合にトランザクションを使う
# 複数の処理を一つの処理と捉えて、その処理全てが成功/失敗するかどうかをチェックするもの


# order.save_with_update_line_foods!(posted_line_foods)が成功した場合-> status: :no_contentと空データreturn, 失敗した場合 -> status: :internal_server_errorをreturn