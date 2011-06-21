MWeegoo::Application.routes.draw do
  get "update_sub_categories/:category_id", :to => "ajax#update_sub_categories"
  
  get "points_of_interest/browse", :to => "points_of_interest#browse_categories", :as => "browse_categories_points_of_interest"
  get "points_of_interest/browse/:category_id", :to => "points_of_interest#browse_sub_categories", :as => "browse_sub_categories_points_of_interest"
  
  get "points_of_interest/map", :to => "points_of_interest#map", :as => "map"
  get "points_of_interest/categories_map/:category_id", :to => "points_of_interest#categories_map", :as => "categories_map"
  get "points_of_interest/sub_categories_map/:sub_category_id", :to => "points_of_interest#sub_categories_map", :as => "sub_categories_map"
  
  resources :points_of_interest do
    member do
      get "been"
      get "not_been"
      get "want_to_go"
      get "dont_want_to_go"

      get "been_users"
      get "want_to_go_users"
      get "been_friends"
      get "want_to_go_friends"
    end
  end
  
  resources :venues
  resources :events
  
  get "authentications/create"

  match "/auth/:provider/callback" => "authentications#create"
  
  devise_for :users
  
  root :to => "main#index"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
