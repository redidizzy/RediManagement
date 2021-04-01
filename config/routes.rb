Rails.application.routes.draw do
  resources :artifacts, except: [:index, :new, :create, :edit, :update]
  resources :projects
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }
  root 'welcome#index'

  get 'projects/:id/artifacts', to: 'artifacts#index', as: 'artifacts'
  get 'projects/:id/artifacts/new', to:'artifacts#new', as: 'new_artifact'
  post 'projects/:id/artifacts', to:'artifacts#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
