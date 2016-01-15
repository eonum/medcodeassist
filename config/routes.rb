Rails.application.routes.draw do
  namespace :api do
    namespace :v1, :defaults => {:format => :json} do
      resources :tokens, :only => [:create]
    end
  end
end
