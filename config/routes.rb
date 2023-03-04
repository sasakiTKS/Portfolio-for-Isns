Rails.application.routes.draw do

  devise_for :members, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  scope module: :public do
    root to: 'posts#index'
    get 'members/confirm' => 'members#confirm'
    get 'members/likes' => 'members#likes'
    get "members/mypage" => "members#mypage"
    get "members/unsubscribe" => "members#unsubscribe"
    patch "members/withdraw" => "members#withdraw"
    resources :members, only: [:update, :show] do
      resource :relationships, only: [:create, :destroy]
      get :followers, on: :member
      get :follows, on: :member
    end

    resources :posts do
      resource :likes, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    get "sort_new" => "posts#index"
    get "sort_old" => "posts#index"
    get "sort_like" => "posts#index"
    get "search" => "searches#search"
    resources :tags, except: [:index, :show, :edit, :new, :create, :update, :destroy] do
      get 'posts', to: 'posts#search'
    end
    resources :notifications, only: [:index] do
      collection do
        delete 'destroy_all'
      end
    end
  end

  devise_scope :member do
    post 'members/guest_sign_in', to: 'members/sessions#guest_sign_in'
    get 'members/guest_sign_in', to: 'members/sessions#guest_sign_in'
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  namespace :admin do
    root "posts#index"
    resources :posts, only: [:show, :index, :destroy] do
      resources :comments, only: [:destroy]
    end
    get "comments" => "comments#comments"
    get "sort_new" => "posts#index"
    get "sort_old" => "posts#index"
    get "sort_like" => "posts#index"
    resources :members, only: [:index, :show, :update]
    get "search" => "searches#search"
  end

end
