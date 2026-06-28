Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    post 'auth/register', to: 'auth#register'
    post 'auth/login', to: 'auth#login'

    get 'users/me', to: 'users#me'
    put 'users/me', to: 'users#update'
    patch 'users/me', to: 'users#update'
    get 'users/me/pets', to: 'users#my_pets'

    resources :pets, only: [:index, :show, :create, :update, :destroy] do
      member do
        post 'publish', to: 'pets#publish'
        post 'unpublish', to: 'pets#unpublish'
      end
    end

    resources :adoption_applications, only: [:index, :show, :create] do
      collection do
        get 'received', to: 'adoption_applications#received'
      end
      member do
        post 'approve', to: 'adoption_applications#approve'
        post 'reject', to: 'adoption_applications#reject'
      end
    end

    resources :messages, only: [:index, :show] do
      collection do
        post 'mark_all_as_read', to: 'messages#mark_all_as_read'
        get 'unread_count', to: 'messages#unread_count'
      end
      member do
        post 'mark_as_read', to: 'messages#mark_as_read'
      end
    end
  end
end
