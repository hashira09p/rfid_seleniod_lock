class ApplicationController < ActionController::Base
  before_action :authenticate_professor_user!
end
