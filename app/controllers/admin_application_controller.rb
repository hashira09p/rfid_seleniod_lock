class AdminApplicationController < ActionController::Base
  before_action :authenticate_admin_user!, except: [:create, :update, :new, :card_scan]
end