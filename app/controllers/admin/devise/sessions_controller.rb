# frozen_string_literal: true

class Admin::Devise::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :new]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user_admin = User.admin.find_by(email: params[:admin_user][:email])
    if user_admin
      flash[:notice] = "Welcome, #{user_admin.firstname}"
      super
    elsif user_admin.nil?
      flash[:alert] = 'Invalid Account or account is not an admin.'
      redirect_to new_admin_user_session_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
