Rails.application.routes.draw do
  get 'front_end/index'
  post '/api/v1/tokenizations/create' # for testing the tokenizations controller
  root 'front_end#index', {:q => "Hello"}
  namespace :api do
    namespace :v1, :defaults => {:format => :json} do
      resources :tokenization, :only => [:create]
      resources :synonyms, :only => [:create]
      resources :code_proposals, :only => [:create]
    end
  end
end
