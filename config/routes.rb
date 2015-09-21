Rails.application.routes.draw do
  resources :questions
  resources :advertisements
  resources :posts
  get 'about' => 'welcome#about'
  root to: 'welcome#index'
end
