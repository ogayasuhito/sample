Rails.application.routes.draw do
  #resources :samples do
  #  resources :comments, only: [:create, :destroy]
  #end

  get '/index', to: 'samples#index'
  post '/index', to: 'samples#index'
  get '/detail', to: 'samples#detail'

  get '/adminLogin', to: 'samples#adminLogin'
  get '/pwdChange', to: 'samples#pwdChange'
  post '/pwdChange', to: 'samples#pwdChangeRegist'
  post '/pwdChangeRegist', to: 'samples#pwdChangeRegist'

  get '/list', to: 'samples#list'
  post '/list', to: 'samples#list'
  get '/listRegist', to: 'samples#listRegist'
  post '/listRegistd', to: 'samples#listRegistd'

  get '/listDelete', to: 'samples#listDelete'

  root 'samples#index'
end
