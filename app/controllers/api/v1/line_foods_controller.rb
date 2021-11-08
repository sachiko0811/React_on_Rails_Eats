# --- ここから追加 ---
module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create] #before_actionではそのコントローラーのメインアクションに入る"前"に行う処理を挟める -> callback

      def create
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable
        end

        set_line_food(@ordered_food) # line_foodインスタンス生成

        if @line_food.save # DBに保存
          render json: {
            line_food: @line_food
          }, status: :created # saveが成功した場合 -> status: :createdと保存したデータを返す
        else
          render json: {}, status: :internal_server_error # if @line_food.saveでfalseだった場合 -> render json~がreturn, もしフロントエンドでエラーの内容に応じて表示を変えるような場合にここでHTTPレスポンスステータスコードが500系になる
        end
      end

      private

      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        if ordered_food.line_food.present? # 新しくline_foodを生成するのか、既に同じfoodに関するline_foodが存在する場合を判断している
          @line_food = ordered_food.line_food
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          } #present?がtrueの場合 -> 既存のline_foodインスタンスの既存の情報を更新(count, activeの２つをupdate)
        else
          @line_food = ordered_food.build_line_food( # 新しくインスタンスを作成
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

# 「早期リターン」とは複雑あるいは重いメイン処理を実行する前に、この処理が不要なケースに当てはまるかどうかをifなどでチェックし、その場合にメイン処理に入らせないことを指す