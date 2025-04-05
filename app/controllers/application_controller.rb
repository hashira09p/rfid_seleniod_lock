class ApplicationController < ActionController::Base
  before_action :authenticate_professor_user!

  def after_sign_in_path_for(resource)
    dashboard_index_path  # or a named route like admin_dashboard_path
  end
end
