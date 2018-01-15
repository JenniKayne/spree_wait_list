Spree::Core::Engine.routes.draw do
  namespace :api do
    resources :stock_requests
  end

  namespace :admin do
    resources :reports, only: %i[index] do
      get 'stock_requests', on: :collection
    end
  end
end
