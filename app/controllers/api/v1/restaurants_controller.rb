# --- ここから追加 ---
module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        restaurants = Restaurant.all

        render json: {
          restaurants: restaurants
        }, status: :ok
      end
    end
  end
end
# --- ここまで追加 ---
