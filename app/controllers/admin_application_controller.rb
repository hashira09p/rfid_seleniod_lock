class AdminApplicationController < ActionController::Base
  before_action :authenticate_admin_user!, except: [:create, :update, :new, :card_scan]

  before_action :set_role_user

  private

  def set_role_user
    @role_user = current_admin_user&.role
  end
end