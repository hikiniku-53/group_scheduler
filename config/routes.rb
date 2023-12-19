Rails.application.routes.draw do
  devise_for :members
  devise_for :groups
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
