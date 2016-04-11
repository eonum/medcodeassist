Rails.application.routes.draw do
  get 'front_end/index'
  post 'front_end/analyse'
  root 'front_end#index'
  namespace :api do
    namespace :v1, :defaults => {:format => :json} do
      resources :tokenizations, :only => [:create]
      resources :synonyms, :only => [:create]
      resources :code_proposals, :only => [:create]
    end
  end
end
