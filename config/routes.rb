Rails.application.routes.draw do
  devise_for :users

  get 'welcome/index'

  get 'welcome/login'

  get 'welcome/signup'

  get 'welcome/about'

  get 'welcome/features'

  get 'welcome/users'

  get 'welcome/profile'

  get 'welcome/inbox'

  get 'welcome/messages'

  get 'welcome/events'

  resources :messagings

  root to: 'welcome#index'
end
