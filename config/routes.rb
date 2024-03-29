Rails.application.routes.draw do
  scope "/api" do
    scope "/v1" do
      resources :routes, only: [:index, :show] do
        resources :route_runs, only: [:show, :index] do
          post :start, on: :member
          post :complete, on: :member
          post :update_location, on: :member
          get :location_status, on: :member
          get :tickets, on: :member
        end
        get 'autocomplete', on: :collection
        get 'all', on: :collection
      end

      resources :tickets, only: [:create, :show, :index] do
        get 'smallImage', on: :member
        post 'boarded', on: :member
      end

      resources :passes, only: [:create, :show, :index]

      resources :payment_details, only: [:create, :show, :index]

      resources :favorite_locations, only: [:create, :show, :index]

      resources :pass_plans, only: [:show, :index]

      devise_for :riders, skip: :sessions, controllers: {registrations: "riders"}
      resources :riders, only: [:create] do
        post 'login', on: :collection
        post 'register_token', on: :collection
        get 'logout', on: :member
        get 'destroy', on: :member
        get 'update_password', on: :member
        get 'suggested_payment_method', on: :collection
      end
    end
  end
  get '/status' => 'application#status'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
