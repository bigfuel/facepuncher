require 'sidekiq/web'

Facepuncher::Application.routes.draw do

  root to: 'projects#show'

  resources :projects do
    member do
      match '/index' => 'projects#show'
    end
  end

  namespace :api do
    resources :project do
      resources :signups
      resources :events
      resources :videos
      resources :images
      resources :feeds
      resources :posts
      resources :facebook_albums
      resources :facebook_events

      resources :polls do
        put 'vote', on: :member
      end

      resources :submissions do
        post 'submit', on: :member
      end
    end
  end

  match '/admin' => 'admin/projects#index', as: 'user_root'

  # ADMIN ROUTES
  devise_for :users

  namespace :admin do
    root to: "projects#index"

    resources :users

    resources :projects do
      post 'queue_deploy', on: :collection

      member do
        get 'activate'
        get 'deactivate'
      end

      resources :signups
      resources :feeds
      resources :facebook_albums
      resources :facebook_events
      resources :view_templates

      resources :videos do
        member do
          get 'approve'
          get 'deny'
        end
      end

      resources :releases do
        member do
          get 'go_live'
        end
      end

      resources :images do
        member do
          get 'approve'
          get 'deny'
        end
      end

      resources :events do
        collection do
          post 'import'
        end
        member do
          get 'approve'
          get 'deny'
        end
      end

      resources :polls do
        resources :choices

        member do
          get 'activate'
          get 'deactivate'
        end
      end

      resources :submissions do
        member do
          get 'approve'
          get 'deny'
        end
      end

      resources :posts do
        member do
          put 'up'
          put 'down'
          get 'approve'
          get 'deny'
        end
      end
    end

    mount Sidekiq::Web => '/sidekiq'
  end
end
