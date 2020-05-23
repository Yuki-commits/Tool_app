Rails.application.routes.draw do
  root 'home#top'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :tools, except: [:show] do
    resource :tool_users, only: [:create, :update]
    collection do
      get :search
    end
  end

  resources :users, except: [:new, :show] do
    collection do
      get :search
    end
    member do
      post :approval
    end
  end

  resources :groups, except: [:show]
  resources :categories, except: [:show]
  resources :sub_categories, except: [:show, :index]
  resources :other_categories, except: [:show, :index, :new, :create]
  resources :places, except: [:show]

end
