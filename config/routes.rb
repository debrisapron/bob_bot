Rails.application.routes.draw do
  
  scope '/api' do
    resource :users, only: [:create, :destroy]
    resources :messages, only: [:index, :create]
  end

end