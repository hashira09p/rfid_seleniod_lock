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
      resources :professor do
        member do
          patch :toggle_status
        end
    end
      resources :users
      resources :schedules
      resources :rooms
      resources :room_display
      get "room_statuses", to: "room_display#room_statuses"
      resources :time_track
      resources :dashboard
    end
    root 'admin/dashboard#index', as: :admin_root
    post 'registrations', to: 'admin/cards#registrations'
  end

  scope module: 'admin' do
    resources :rfids
    resources :cards
  end
  post 'card_scan', to: 'admin/cards#card_scan'

  constraints(ProfessorDomainConstraint.new) do
    scope module: 'professor' do
      devise_for :users, controllers: {
        sessions: 'professor/users/sessions'
      }, as: :professor
    end
    root 'professor/professor#index', as: :professor_root
  end
end
