Rails.application.routes.draw do
  root to: 'homes#top'
  get      'users/terms'          => 'users#terms',         as: 'terms'
  get      '/contents/index_age0' => 'contents#index_age0', as: 'contents_age0'
  get      '/contents/index_age1' => 'contents#index_age1', as: 'contents_age1'
  get      '/contents/index_age2' => 'contents#index_age2', as: 'contents_age2'
  get      '/contents/index_age3' => 'contents#index_age3', as: 'contents_age3'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    confirmations:      'users/confirmations'
                                    }
  resources :contents,   only:[:new, :create, :index, :show, :update, :destroy] do
    resource :likes,     only:[:create, :destroy]
    resource :favorites, only:[:create, :destroy]
    resources :comments, only:[:create, :destroy]
    collection do
      get 'search'
    end
  end
  resources :users,      only:[:index, :show, :update, :destroy] do
    get 'user_likes'      => 'users#user_likes'
    get 'user_favorites'  => 'users#user_favorites'
    get 'user_followings' => 'users#user_followings'
    get 'user_followers'  => 'users#user_followers'
    collection do
      get 'search'
    end
  end
  resources :relationships, only:[:create, :destroy]
  resources :messages,      only:[:create]
  resources :rooms,         only:[:create,:show]
  resources :notifications, only:[:index]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
