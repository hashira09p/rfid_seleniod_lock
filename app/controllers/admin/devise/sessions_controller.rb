# frozen_string_literal: true

class Admin::Devise::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :new]
  skip_before_action :require_no_authentication, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    sign_out(current_user) if current_user # prevent "already signed in" error

    user = User.find_by(email: params[:user][:email])

    if user&.admin? || user&.super_admin?
      flash[:notice] = "Welcome, #{user.firstname}"
      super
    else
      flash[:alert] = 'Invalid account or insufficient privileges.'
      redirect_to new_user_session_path
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
