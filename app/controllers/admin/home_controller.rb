class Admin::HomeController < AdminApplicationController
  before_action :authenticate_admin_user!, except: [:create]
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.order(:firstname)

    # filtering
    if params[:fullname].present?
      search_query = params[:fullname].strip.downcase

      @users = @users.where(
        'LOWER(firstname) LIKE :query OR LOWER(middlename) LIKE :query OR LOWER(lastname) LIKE :query OR ' \
          'LOWER(CONCAT(firstname, " ", middlename, " ", lastname)) LIKE :query OR ' \
          'LOWER(CONCAT(firstname, " ", lastname)) LIKE :query',
        query: "%#{search_query}%"
      )
    end

    @users = @users.where(academic_college: params[:academic_college]) if params[:academic_college].present?
    @users = @users.where(role: params[:role]) if params[:role].present?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "professor"

    surname = @user.lastname&.upcase || "DEFAULT"
    generated_password = "#{surname}123!"

    @user.password = generated_password
    @user.password_confirmation = generated_password

    if @user.save
      flash[:notice] = "Professor #{@user.firstname} #{@user.lastname} created successfully! Password: #{generated_password}"
      redirect_to home_index_path
    else
      flash[:alert] = "Failed to create professor: #{@user.errors.full_messages.join(', ')}"
      render :new
    end
  end

  def edit;
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Professor updated successfully!"
      redirect_to home_index_path
    else
      flash[:alert] = "Failed to update professor: #{@user.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  def toggle_status
    @user = User.find(params[:id])
    new_status = params[:status] == 'active' ? 'active' : 'inactive'

    @user.update(status: new_status)

    if new_status == 'active'
      @user.cards.update_all(status: 1)
    else
      @user.cards.update_all(status: 0)
    end

    flash[:notice] = "#{@user.firstname}'s status and associated cards have been updated to #{new_status.capitalize}."
    redirect_to home_index_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :firstname, :middlename, :lastname,
      :academic_college, :email, :role, :password, :password_confirmation
    )
  end
end