Rails.application.routes.draw do
  devise_for :users, skip: :registrations
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'devise/registrations',
      as: :user_registration do
        get :cancel
      end
  end
  
  resources :posts, only: [:show, :destroy] do
    resources :comments, only: [:destroy], controller: 'posts', action: 'destroy_comment'
  end
  get 'posts/page/:page' => 'posts#index', as: 'posts', constraints: { page: /[0-9]+/ }
  post 'posts/page/:page' => 'posts#create', constraints: { page: /[0-9]+/ }
  resources :friendships, only: [:index, :destroy, :update]
  resources :personal_infos, except: [:show, :index, :new]
  
  resources :messages, only: [:index]
  get 'messages/:user_id/:page' => 'messages#show', :as => 'messages_user', constraints: { user_id: /[0-9]+/, page: /[0-9]+/ }
  post 'messages/:user_id/:page' => 'messages#create', constraints: { user_id: /[0-9]+/, page: /[0-9]+/ }
  
  resources :users, only: [], path: '', constraints: { user_id: /[0-9]+/} do
    resources :posts, only: [:destroy] do
      resources :comments, only: [:destroy], controller: 'posts', action: 'destroy_comment'
    end
    resources :friendships, only: [:index, :destroy, :create, :update]
    resources :personal_infos, only: [:index], path: '', constraints: { user_id: /[0-9]+/}
  end
  get ':user_id/posts/page/:page' => 'posts#index', as: 'user_posts', constraints: { user_id: /[0-9]+/, page: /[0-9]+/ }
  post ':user_id/posts/page/:page' => 'posts#create', constraints: { user_id: /[0-9]+/, page: /[0-9]+/ }
  
  put '(:user_id)/posts(/:post_id/comments)/:id' => 'posts#like', constraints: { user_id: /[0-9]+/, post_id: /[0-9]+/, id: /[0-9]+/ }
  
  get 'all_posts/:page' => 'posts#all', as: 'all_posts', constraints: { page: /[0-9]+/ }
  post 'all_posts/:page' => 'posts#create', constraints: { page: /[0-9]+/ }
  
  get 'user_search/:page' => 'users#index', as: 'user_search', constraints: { page: /[0-9]+/ }
  
  root 'personal_infos#index'

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
