Rails.application.routes.draw do
  get 'front_end/index'
  root 'front_end#index'
  namespace :api do
    namespace :v1, :defaults => {:format => :json} do
      resources :tokenization, :only => [:create]
      resources :synonyms, :only => [:create]
      resources :code_proposals, :only => [:create]
    end
  end
end
