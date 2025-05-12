Rails.application.routes.draw do
  # Accessible for both admin domain
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

      resources :rooms do
        member do
          patch :toggle_status
        end
      end

      resources :users
      resources :schedules
      resources :room_display
      get "room_statuses", to: "room_display#room_statuses"
      resources :time_track
      resources :dashboard

      get 'history/index'
      get 'history/professor'
      get 'history/card'
      get 'history/room'
      get 'history/schedule'
    end
    root 'admin/dashboard#index', as: :admin_root
    post 'registrations', to: 'admin/cards#registrations'
  end

  # Accessible for both admin and professor domain
  scope module: 'admin' do
    resources :rfids
    resources :cards do
      member do
        patch :toggle_status
      end
    end
  end
  post 'card_scan', to: 'admin/cards#card_scan'

  # Accessible for both professor domain
  constraints(ProfessorDomainConstraint.new) do
    scope module: 'professor' do
      devise_for :users, controllers: {
        sessions: 'professor/users/sessions'
      }, as: :professor
    end
    root 'professor/professor#index', as: :professor_root
  end
end
