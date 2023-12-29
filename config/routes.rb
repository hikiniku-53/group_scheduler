Rails.application.routes.draw do
  devise_for :members
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :member do
    get 'members/:id/edit' => 'members/registrations#edit', as: :edit_other_member_registration
    match 'members/:id', to: 'members/registrations#update', via: [:patch, :put], as: :other_member_registration
  end

  root to: 'homes#top'



end
