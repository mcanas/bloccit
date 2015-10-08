Rails.application.routes.draw do
  resources :questions
  resources :advertisements

  resources :topics do
    resources :posts, except: [:index]
    resources :sponsored_posts, except: [:index]
  end

  resources :users, only: [:new, :create]

  get 'about' => 'welcome#about'
  root to: 'welcome#index'
end
