DummyApp::Application.routes.draw do
  # Needed for :show_in_app tests
  resources :players, only: [:show]

  devise_for :users
  mount MmoStarterKit::Engine => '/admin', as: 'mmo_starter_kit'
  root to: 'mmo_starter_kit/main#dashboard'
  # https://github.com/sferik/mmo_starter_kit/issues/362
  get ':controller(/:action(/:id(.:format)))'
end
