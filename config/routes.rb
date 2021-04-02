Rails.application.routes.draw do
  resources :user_projects, only: [ :destroy ]
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

  get 'projects/:id/users', to: 'projects#users', as: 'project_users'
  post 'projects/:id/add_user', to: 'projects#add_user', as: 'project_users_add'

  get 'plan/edit', to:'tenants#edit', as: 'edit_plan'
  match 'plan/edit', to:'tenants#update', via: [ :put, :patch ], as: 'update_plan'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
