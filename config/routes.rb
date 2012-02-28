Starter::Application.routes.draw do
  match "sign_out" => "sessions#destroy", :via => [:get, :delete, :post]
  get "sign_in" => "sessions#new"
  post "sign_in" => "sessions#create"
  
  root :to => "home#index", :as => :home
  
  get "contact" => "home#contact"
  get "about" => "home#about"
  get "denied" => "home#denied"
  
  get "dashboard" => "user#dashboard"
  get "profile" => "user#profile"
  put "profile" => "user#save"
  get "settings" => "user#settings"
  post "settings" => "user#save_settings"
  get "password" => "user#password"
  post "password" => "user#change_password"
  
  match "search" => "search#index", :via => [:get, :post]
  
  resources :sessions
  
  resources :staff do
    resources :roles
    
    resources :photos do 
      member do
        get "download"
        put "default"
      end
    end
    
    member do
      get "password"
      put "password" => "staff#reset_password"
      get "terminate"
      put "terminate" => "staff#save_terminate"
      get "nok"
      put "nok" => "staff#save_nok"
      post "nok" => "staff#save_nok"
      get "employment"
      put "employment" => "staff#update_employment"
      put "unlock"
      put "lock" 
    end
    
    collection do
      get "search"
      get "search/active" => "staff#search_active"
      get "terminated" => "staff#inactive"
      get "recent"
    end
  end
  
  namespace :admin do
    resources :organisations do
      resources :roles, :controller => "permissions"
      resources :locations
    end
  end
       
  match "*path" => "application#render_not_found"
end
