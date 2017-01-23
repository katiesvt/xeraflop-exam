Rails.application.routes.draw do
  root "index#index"

  namespace :api do
    namespace :v1 do
      get 'recommend_products', controller: :recommend
    end
  end
end
