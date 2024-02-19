Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  mount ActionCable.server => '/cable'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :profiles do
    collection do
      get :show_my_profile
      get :dsiplay_profile_with_posts
    end
  end

  resources :posts do
    collection do
      get :show_my_post
      post :toggle_like
    end
  end

  resources :comments

  resources :follow_requests, only: [:create, :index] do
    collection do
      patch :handle_requests
      get :followers
      get :following
      delete :unfollow
    end
  end

  resources :messages, only: [:index, :create] do
    collection do
      get :chat_history
    end
  end

  resources :payments, only: [:create]
   
end