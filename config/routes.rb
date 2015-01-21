# -*- encoding : utf-8 -*-
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }, :path => '', :path_names => {
    :sign_up => 'signup',
    :sign_in => 'login', 
    :sign_out => 'logout',
    # :finish_signup => 'users#finish_signup'
  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  concern :voteable do
    patch :vote_up, on: :member
    patch :vote_down, on: :member
  end

  concern :commentable do
    resources :comments, concerns: :voteable
  end

  resources :questions, concerns: [:commentable, :voteable], shallow: true do
    resources :answers, concerns: [:commentable, :voteable] do
      patch :make_best, on: :member
    end
  end

  resources :users do

  end

  get '/profile/:id', to: 'users#show', as: 'profile'
  match 'finish_signup', to: 'users#finish_signup', as: 'finish_signup', via: [:get]
  get '/tag/:tag_name', to: 'questions#index', as: 'tag'
  get '/questions/(:filter)', to: 'questions#index'

  root 'questions#index'

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
