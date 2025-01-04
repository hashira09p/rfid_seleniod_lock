Rails.application.routes.draw do
  constraints(AdminDomainConstraint.new) do
    scope module: 'admin' do
      devise_for :users, controllers: {
        sessions: 'admin/users/sessions'
      }, as: :admin
      resources :home
      resources :rfids
    end
    root 'admin/home#index', as: :admin_root
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
