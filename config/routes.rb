Rails.application.routes.draw do
  constraints(AdminDomainConstraint.new) do
    scope module: 'admin' do
      devise_for :users, controllers: {
        sessions: 'admin/devise/sessions',
        confirmations: 'admin/devise/confirmations',
        mailers: 'admin/devise/mailers',
        passwords: 'admin/devise/passwords',
        registrations: 'admin/devise/registrations',
        shared: 'admin/devise/shared',
        unlocks: 'admin/devise/unlocks'
      }, as: :admin
      resources :home
      resources :rfids
      resources :cards
      resources :users
      resources :schedules
      resources :rooms
      resources :room_display
    end
    root 'admin/home#index', as: :admin_root
    post 'registrations', to: 'admin/cards#registrations'
    post 'card_scan', to: 'admin/cards#card_scan'
  end

  constraints(ProfessorDomainConstraint.new) do
    scope module: 'professor' do
      devise_for :users, controllers: {
        sessions: 'professor/users/sessions'
      }, as: :professor
    end
    root 'professor/home#index', as: :professor_root
  end
end
