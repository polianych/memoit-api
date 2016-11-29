Rails.application.routes.draw do
  scope '/api' do
    resources :users
    resources :password_resets
    resources :rss_channels
    resources :posts
    post   'sign_in',  to: 'sessions#create'
    delete 'sign_out', to: 'sessions#destroy'
    post   'oauth/sign_in',    to: 'oauth#login'
    post   'oauth/sign_up',    to: 'oauth#sign_up'
  end
end
