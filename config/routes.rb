Rails.application.routes.draw do
  constraints(AdminDomainConstraint.new) do
    scope module: 'admin' do
      devise_for :users, controllers: {
        sessions: 'admin/users/sessions'
      }, as: :admin
    end
  end

  constraints(ProfessorDomainConstraint.new) do
    scope module: 'professor' do
      devise_for :users, controllers: {
        sessions: 'professor/users/sessions'
      }, as: :professor
    end
  end
end
