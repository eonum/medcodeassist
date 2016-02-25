Rails.application.routes.draw do
  namespace :api do
    namespace :v1, :defaults => {:format => :json} do
      resources :tokenization, :only => [:create]
      resources :synonyms, :only => [:create]
      resources :code_proposals, :only => [:create]
    end
  end
end
