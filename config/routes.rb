Rails.application.routes.draw do
  # --- ここから追加 ---
  namespace :api do
    namespace :v1 do
      resources :restaurants do #特定のリソースに対するルーティングではresources使う
        resources :foods, only: %i[index]
      end
      resources :line_foods, only: %i[index create]
      put 'line_foods/replace', to: 'line_foods#replace' #「'line_foods_replace'というURLに対してPUTリクエストがきたら、line_foods_controller.rbのreplaceメソッドを呼ぶ」
      resources :orders, only: %i[create]
    end
  end
  # --- ここまで追加 ---
end

#do... end でルーティングを定義
#namespace:hoge で名前空間を付与。コントローラーをグルーピングし、またURLにもその情報を付与

# resources:hoge で　:hogeというリソースに対して７つ(HTTPメソッドであるget, post, deleteなど)のルーティングが自動的に作成される
# only: %i[index]のかたちで特定のルーティングしか生成しない

# get 'hoge/fuga, to: 'hoge#hoge_fuga' → GETリクエストのルーティングを生成
# resources :hogeとの違いは、アプリケーション独自のルーティングとコントローラー、そのアクションに対応させられるという点
#「原則はresources、resourceで書く、例外的に必要であればput ... to:も許容する」というルールがいいかと思います。後者は自由度が高い一方で、コード量は増えますし、またその量に応じて管理も大変