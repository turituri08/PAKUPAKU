Rails.application.routes.draw do
  root to: 'homes#top'
  devise_for :users
  resources :contents
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
