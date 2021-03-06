Sport::Application.routes.draw do

  mount RedactorRails::Engine => '/redactor_rails'

  devise_for :users 
      
 resources :users, only: [:index, :show]
  post '/user_search' => "users#search"
  get '/user_index_search' => "users#index_search"
  get '/user_email_index_search' => "users#email_index_search"
  resources :friendships
  get '/incoming_requests' => "friendships#incoming"
  get '/outgoing_requests' => "friendships#outgoing"
  get '/reverse_messages' => "messages#reverse"
  resources :messages 
  post '/receiver_search' => "messages#receiver_search"
  get 'chats' => "messages#chat_index"
  get 'chat/:id' => "messages#chat_show", as: 'chat'
  
  resources :microposts
  post '/micropost_search' => "microposts#search"
  




  get '/events_master' => "events#master"
  get '/events_all' => "events#all"
  get '/events_joined' => "events#joined"
  post '/event_search' => "events#search"
  get '/event_index_search' => "events#index_search"
  resources :events do
    post :join
 end

  #match '/join',    :to => 'events#join'
  #put "posts/:id" => "events#join"
 
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):

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
  root to: 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
