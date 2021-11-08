module Api
  module V1
    class FoodsController < ApplicationController
      def index
        restaurant = Restaurant.find(params[:restaurant_id]) #リクエスト時にparams[:restaurant_id]というパラメーターを受け取る、この中には店舗のidが入る, そのidをもとに全てのRestaurantのなかからfindで対応するデータを一つだけ探し出し、その結果をrestaurantという変数に代入
        foods = restaurant.foods # restaurantにはparams[:restaurant_id]に対するRestaurantが一つ入っている, そのrestaurantのリレーション先のfoods一覧をrestaurant.foodsと書くことで取得可能となる, そのrestaurant.foodsの結果をfoodsという変数に代入

        render json: { #JSON形式でfoodsというデータ一覧を返す, JSON: JSのobj記法を元にしたデータのかたち
          foods: foods
        }, status: :ok
        end
      end
    end
  end

# class名: FoodsController, Foodモデルから生成されるインスタンス一覧を返したい -> indexという名前のアクション名にしている

# JSON以外にもXMLが主要なデータ形式だったが、JSONの方が記述量が少なく、またその他メリットがあることから今ではJSON形式でのデータのやりとりがWebアプリのスタンダードに