Rails.application.routes.draw do
  resources :characters
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'arena' => 'arena#show'
  post 'choose_player' => 'arena#choose_player'
  get 'fight/:arena_id' => 'arena#fight'

end
