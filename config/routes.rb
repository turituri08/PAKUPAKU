Rails.application.routes.draw do
  root to: 'homes#top'
  get      '/contents/index_age0' => 'contents#index_age0', as: 'contents_age0'
  get      '/contents/index_age1' => 'contents#index_age1', as: 'contents_age1'
  get      '/contents/index_age2' => 'contents#index_age2', as: 'contents_age2'
  get      '/contents/index_age3' => 'contents#index_age3', as: 'contents_age3'
  devise_for :users
  resources :contents,   only:[:new, :create, :index, :show, :update, :destroy] do
    resource :likes,     only:[:create, :destroy]
    resource :favorites, only:[:create, :destroy]
    resources :comments, only:[:create, :destroy]
  end
  resources :users,         only:[:index, :show, :update]
  resources :relationships, only:[:create, :destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
