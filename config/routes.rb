Rails.application.routes.draw do
  resources :contests, except: [:destroy] do
    member do
      post 'problem', action: 'add_problem'
      delete 'problem/:problem_id', action: :remove_problem, as: :remove_problem

      post 'problem/:problem_id/up', action: :up_problem, as: :up_problem
      post 'problem/:problem_id/down', action: :down_problem, as: :down_problem

      post 'join', action: 'join'
      post 'leave', action: 'leave'
    end
  end

  get '/users/edit', to: 'users#edit', as: :edit_user
  patch '/users/update', to: 'users#update', as: :update_user
  get '/users/new', to: 'sessions#new_user', as: :new_user
  post '/users', to: 'sessions#create_user', as: :create_user
  resources :users, only: [:index, :show]

  scope '/poj' do
    get 'weekly', to: 'poj#weekly', as: :poj_weekly
    get 'recent', to: 'poj#recent', as: :poj_recent
    constraints(problem_id: /\d+/) do
      get ':problem_id', to: 'poj#show', as: :poj
      post ':problem_id/update_tags', to: 'poj#update_tags', as: :update_poj_tags
      get ':problem_id/edit_tags', to: 'poj#edit_tags', as: :edit_poj_tags
    end
  end

  scope '/aoj' do
    get 'weekly', to: 'aoj#weekly', as: :aoj_weekly
    get 'recent', to: 'aoj#recent', as: :aoj_recent
    constraints(problem_id: /\d+/) do
      get ':problem_id', to: 'aoj#show', as: :aoj
      post ':problem_id/update_tags', to: 'aoj#update_tags', as: :update_aoj_tags
      get ':problem_id/edit_tags', to: 'aoj#edit_tags', as: :edit_aoj_tags
    end
  end

  scope '/codeforces' do
    get 'weekly', to: 'codeforces#weekly', as: :codeforces_weekly
    get 'recent', to: 'codeforces#recent', as: :codeforces_recent
    constraints(problem_id: /\d+[A-Z]\d?/) do
      get ':problem_id', to: 'codeforces#show', as: :codeforces
      post ':problem_id/update_tags', to: 'codeforces#update_tags', as: :update_codeforces_tags
      get ':problem_id/edit_tags', to: 'codeforces#edit_tags', as: :edit_codeforces_tags
    end
  end

  get 'codeboard', to: 'codeboard#show'
  post 'codeboard', to: 'codeboard#create'

  get '/auth/:provider', to: 'sessions#dummy', as: :auth
  get '/auth/:provider/callback', to: 'sessions#create', as: :auth_callback
  get '/login', to: 'sessions#new', as: :new_session
  get '/logout', to: 'sessions#destroy', as: :destroy_session

  resources :tags, only: [:index, :create]
  get '/tagged/:id', to: 'tags#show', as: :tag

  resources :activities, only: [:index]

  root 'home#index'
end
