Rails.application.routes.draw do
  get 'labels/show'

  resources :labels, only: [:show]
  resources :questions
  resources :advertisements

  resources :topics do
    resources :posts, except: [:index]
    resources :sponsored_posts, except: [:index]
  end

  resources :posts, only: [] do
    resources :comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]

    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote
  end

  resources :users, only: [:show, :new, :create]
  resources :sessions, only: [:new, :create, :destroy]

  post 'confirm' => 'users#confirm'
  get 'about' => 'welcome#about'
  root to: 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update]

      resources :topics, only: [:index, :show] do
        resources :posts, only: [:index, :show, :create]
      end

      resources :topics, except: [:edit, :new]
      resources :posts, except: [:edit, :new, :create]

      resources :posts, only: [:index, :show] do
        resources :comments, only: [:index, :show]
      end

      resources :comments, only: [:index, :show]
    end
  end
end
