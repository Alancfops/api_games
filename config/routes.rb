Rails.application.routes.draw do
  namespace :api do
    resources :jogos
  end
end