Rails.application.routes.draw do
  # get 'topics/new'

  get 'sessions/new'
  # get 'users/new'
  get 'pages/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
  get 'pages/help'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # get '/users/:id/edit', to: 'users#edit'
  # post '/users/:id/edit', to: 'users#update'
  resources :users

  # get '/topics/:id/edit', to: 'topics#edit'
  # post '/topics/:id/edit', to: 'topics#update'
  # delete '/topics/:id/edit', to: 'topics#destroy'
  resources :topics
  # 松田変更
  get '/topics', to: 'topics#index'
  get '/topics?lstScrtop=#', to: 'topics#index'
  # 初期表示用
  get '/topics/show?topic_id=#&lstScrtop=#', to: 'topics#show'

  #resources :favorites
  get 'favorites/show', to: 'favorites#show'
  get 'favorites/index', to: 'favorites#index'
  get '/favorites', to: 'favorites#index'

  #post '/favorites/:topic_id/create', to: 'favorites#create'
  #post '/favorites/:topic_id/destroy', to: 'favorites#destroy'
  get '/favorites/add', to: 'favorites#add'
  get '/favorites/remove', to: 'favorites#remove'
  get '/favorites/addfromshow', to: 'favorites#addfromshow'
  get '/favorites/removefromshow', to: 'favorites#removefromshow'

  # get 'users/:id' => 'users#show'

  get '/comments', to: 'comments#index'
  get '/comments/new?topic_id=#&scrtop=#', to: 'comments#new'
  post '/comments', to: 'comments#create'

  # get 'users/:id' => 'users#show'
end
