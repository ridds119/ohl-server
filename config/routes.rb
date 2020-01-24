Rails.application.routes.draw do
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
  post 'user/image/:id/', controller: :users, action: :imageUpload
  # get 'user/image/:id/', controller: :users, action: :fetchImage
  get 'welcome/index'
  get 'welcome/show'
  # get 'users',controller: :welcome, action: :show
  root :to => "welcome#index" 
end
