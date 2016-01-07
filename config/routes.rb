Rails.application.routes.draw do
  namespace :api do
    namespace :v1, :defaults => {:format => :json} do
      resources :highlighted_words, :only => [:create]
    end
  end
end
