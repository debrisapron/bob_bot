Rails.application.routes.draw do
  
  scope '/api' do
    resources :users, only: :create
    resources :messages, only: [:index, :create]
  end

end