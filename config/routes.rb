VirtualMuseum::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations",
                                      :omniauth_callbacks => "omniauth_callbacks" }
  resources :users
  resources :pages do
    get 'P:page_summaries', :action => :index, :on => :collection
    get ':id/:page_states', :action => :show, :on => :collection
    resources :comments do
      post :approve
      post :disapprove
    end
    member do
      get :subscribe
      get :unsubscribe
      get 'unsubscribe-via-email' => :unsubscribe_via_email, as: :unsubscribe_via_email
    end
  end
  resources :resources do
    get 'P:resources', :action => :index, :on => :collection
  end

  resources :tags,       only: [:show]
  resources :categories, only: [:show]
  resources :page_types, only: [:show]
end

