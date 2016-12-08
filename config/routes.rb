Rails.application.routes.draw do
  scope '/api' do
    resources :users, only: [:create, :show, :update]
    resources :password_resets
    resources :subscriptions, only: [:index, :create, :destroy]
    resources :rss_channels, only: [:index, :show]
    resources :rss_categories, only: [:index, :show]
    resources :posts
    post   'sign_in',  to: 'sessions#create'
    delete 'sign_out', to: 'sessions#destroy'
    post   'oauth/sign_in',    to: 'oauth#login'
    post   'oauth/sign_up',    to: 'oauth#sign_up'
  end
end
