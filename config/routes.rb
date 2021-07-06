Rails.application.routes.draw do
  root to: 'homes#top'
  devise_for :users
  resources :contents do
    resource :likes,     only:[:create, :destroy]
    resource :favorites, only:[:create, :destroy]
    resources :comments, only:[:create, :destroy]
  end
  resources :users, only:[:show, :update]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
