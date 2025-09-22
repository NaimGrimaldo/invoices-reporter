# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health', to: 'api#health'

  namespace :api do
    namespace :v1 do
      resources :invoices, only: [:index]
    end
  end
end
