class Admin::HomeController < AdminApplicationController
  before_action :authenticate_admin_user!, except: [:create]

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

  private

  def user_params
    params.require(:user).permit(
      :firstname, :middlename, :lastname,
      :academic_college, :email, :password, :password_confirmation
    )
  end
end