# --- ここから追加 ---
module Api #名前空間(module -> 部品), moduleでclassをまとめたり、名前空間を表すことができる
  module V1
    class RestaurantsController < ApplicationController #rubyでは継承を継承先 < 継承元で表す　=> ApplicationConrollerを継承したRestaurantsController
      def index # index method
        restaurants = Restaurant.all # Restaurantsモデルを全取得してrestaurantsという変数に代入

        render json: {  # JSON形式でデータを返却
          restaurants: restaurants
        }, status: :ok # -> リクエストが成功、(HTTP) 200 OKとともにデータを返す
      end
    end
  end
end
# --- ここまで追加 ---

# 名前空間を設定すると、一つのモデルの中で、いくつかのCRUD処理を行える、機能ごとに実装追加可能 -> codeが複雑化しない

#　このコントローラーではリクエストにパラメーターは不要で、Restaurant.allがreturn

#class A < B => Bを継承したAを定義できる