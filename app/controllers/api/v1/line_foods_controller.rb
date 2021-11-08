# --- ここから追加 ---
module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create]

      def create
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      private

      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end
# --- ここまで追加 ---

# アクションの実行前にフィルタとして before_action : フィルタアクション名 を定義できる -> 今回の例だとcreateの実行前に、set_foodを実行することができる, :onlyオプションをつけることで、特定のアクションの実行前にだけ追加できる

# set_foodはこのコントローラーの中でしか呼ばれないaction, そのためprivateにする

# set_foodの中ではparams[:food_id]を受け取って、対応するFoodを１つ抽出し、@ordered_foodというインスタンス変数に代入 -> このあと実行されるcreateアクションの中でも@ordered_foodを参照可能

# !!注意　-> インスタンス変数(どこからでも参照できる)は便利だけどグローバルに定義するときのみ使うべき

# ローカル変数(@をつけない変数)の場合、そのスコープでしか使われないため心配がない


## 例外パターン(他店舗での仮注文が既にある場合) ##
# LineFood.active.other_restaurant(@ordered_food.restaurant.id)は複数のscope(active, other_resrtaurant)を組み合わせて「他店舗でアクティブなLineFood」をActiveRecord_Relationのかたちで取得　-> それが存在するかどうかをexists?で判断　-> if it's true, then return JSONデータ

# JSONの中身にはexisting_restaurantで既に作成されている他店舗の情報と、new_restaurantでこのリクエストで作成しようとした新店舗の情報の２つをreturn, and return "406 Not Acceptable"HTTPレスポンスステータスコード