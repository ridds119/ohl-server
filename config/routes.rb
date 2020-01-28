Rails.application.routes.draw do
  Rails.application.routes.default_url_options[:host] = "ohl.api.localhost"
  devise_for :users,
             defaults: { format: :json },
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }
  resources :users
  post 'users/image/:id/', controller: :users, action: :imageUpload
  get 'users/image/:id/', controller: :users, action: :fetchImage
  get 'welcome/index'
  get 'welcome/show'
  # get 'users',controller: :welcome, action: :show
  root :to => "welcome#index" 
  post '/rails/active_storage/direct_uploads' => 'direct_uploads#create'
end
