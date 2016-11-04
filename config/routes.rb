Rails.application.routes.draw do
  scope '/api' do
    resources :users
    resources :password_resets
    post   'sign_in',  to: 'sessions#create'
    delete 'sign_out', to: 'sessions#destroy'
    post   'oauth',    to: 'oauth#create'
  end
end
