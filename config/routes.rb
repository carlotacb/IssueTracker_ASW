Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => 'users/omniauth_callbacks', :sessions => "users/sessions" } 
  get '/users/current_user' => "users#the_current_user", as: :current_user
  resources :issues
  resources :users
  resources :issues do
    resources :comments
  end
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
  #get '/auth/google_oauth2/callback', to: 'users#auth'
  root 'issues#index'
  # get 'update_status' => "issues#update_status"
  get '/issues/:issue_id/comments/:id/attachment' => "comments#show_attachment"
  post '/issues/:issue_id/comments/:id/attachment' => "comments#create_attachment"
  get '/issues/:id/attachment' => "issues#show_attachment"
  post '/issues/:id/attachment' => "issues#create_attachment"
  
  post '/issues/:id/vote' => "issues#vote", as: :vote
  post '/issues/:id/watch' => "issues#watch", as: :watch
  
  put '/issues/:id/status' => "issues#update_status", as: :update_status
end
