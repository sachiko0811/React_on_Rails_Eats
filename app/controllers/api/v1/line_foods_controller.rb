# --- ここから追加 ---
module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create replace] #before_actionではそのコントローラーのメインアクションに入る"前"に行う処理を挟める -> callback

      def index
        line_foods = LineFood.active # 全てのLineFoodモデルの中から、activeなものを取得し、line_foodsという変数に代入
        if line_foods.exists?
          render json: {
            line_food_ids: line_foods.map{ |line_food| line_food.id }, # 登録されているLineFoodのidを配列形式にしている, インスタンスであるline_foodsそれぞれをline_foodという単数形の変数名でとって、line_food.idとして１つずつのidを取得, それが最終的にline_food_ids: ...のプロパティとなる
            restaurant: line_foods[0].restaurant,
            # １つの仮注文につき１つの店舗という仕様のため、line_foodsの中にある先頭のline_foodインスタンスの店舗の情報を詰めている
            count: line_foods.sum { |line_food| line_food[:count] },
            # 各line_foodインスタンスには数量を表す:countがある
            amount: line_foods.sum { |line_food| line_food.total_amount },
            # amountには各line_foodがインスタンスメソッドtotal_amountを呼んで、その数値を合算, 「数量×単価」のさらに合計を計算(フロントエンドで必要)
          }, status: :ok
          else # activeなLineFoodが一つも存在しないcase
            render json: {}, status: :no_content # 空データとstatus: :no_contentを返す
          end
        end

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

       def replace
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food| #each ~ doについて下記
        line_food.update_attribute(:active, false) #line_food.activeをfalseにする
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

# active? -> models/line_food.rbのscope :active, モデル名.スコープ名 === active: trueなLineFoodの一覧がActiveRecord_Relationのかたちで取得可能

# .exists?メソッドは対象のインスタンスのデータがDBに存在するかどうか？をtrue/falseで返すメソッド

# .map method -> 配列やハッシュオブジェクトなどを１つずつ取り出し、.mapより後ろのブロックをあてていく

# 保守性の観点でなるべくデータの計算などはサーバーサイドで担当すべき, ビジネスロジックとしてモデル層ではなく、コントローラー層にベタ書きする

## まとめ
# スコープはActiveRecord_Relationを返す
# exists?でデータがあるかどうかをtrue/falseで判断できる -> 他に nil?/empty?/present?がある

## replace
# before_actionで@ordered_foodをセット

# 他店舗のactiveなLineFood一覧をLineFood.active.other_restaurant(@ordered_food.restaurant.id)で取得し、そのままeachに渡す。各要素に対し、do...end内の処理を実行 -> 他店舗のLineFood一つずつに対してupdate_attributeで更新している。更新内容は引数に渡された(:active, false)で、line_food.activeをfalseにするという意味

## mapとeachのちがい
# map: 最終的に配列をreturn, each: ただ繰り返し処理を行うだけで、そのままでは配列は返さない

#範囲obj.eachの形で、範囲objの中身一つ一つを参照することができる。

## まとめ
# before_actionなどのcallbackには特定のアクションの場合のみ実行する、という指定ができる。 -> only: %i[メソッド名]