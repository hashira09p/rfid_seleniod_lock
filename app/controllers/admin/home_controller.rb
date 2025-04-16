class Admin::HomeController < AdminApplicationController
  before_action :authenticate_admin_user!, except: [:create]
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    if params[:encrypted_params].present?
      begin
        decrypted_params = Rack::Utils.parse_nested_query(EncryptionHelper.decrypt(params[:encrypted_params]))
        params.merge!(decrypted_params)
      rescue => e
        Rails.logger.error "Error decrypting parameters: #{e.message}"
        flash[:error] = "Invalid parameters."
        redirect_to home_index_path and return
      end
    end

    users_query = User.order(:firstname)

    if params[:fullname].present?
      search_query = params[:fullname].strip.downcase
      users_query = users_query.where(
        'LOWER(firstname) LIKE :query OR LOWER(middlename) LIKE :query OR LOWER(lastname) LIKE :query OR ' \
          'LOWER(CONCAT(firstname, " ", middlename, " ", lastname)) LIKE :query OR ' \
          'LOWER(CONCAT(firstname, " ", lastname)) LIKE :query',
        query: "%#{search_query}%"
      )
    end

    users_query = users_query.where(academic_college: params[:academic_college]) if params[:academic_college].present?
    users_query = users_query.where(role: params[:role]) if params[:role].present?

    # Assign the filtered query to the instance variable paginated for HTML
    @users = users_query.page(params[:page]).per(10)

    respond_to do |format|
      format.html  # Render HTML using paginated @users
      format.pdf do
        # Use the full filtered dataset (users_query) for PDF
        pdf = ProfessorPdf.new(users_query)
        send_data pdf.render,
                  filename: "professors.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "professor"
    @user.status = "active"

    surname = @user.lastname&.upcase || "DEFAULT"
    generated_password = "#{surname}123!"

    @user.password = generated_password
    @user.password_confirmation = generated_password

    if @user.save
      flash[:notice] = "Professor #{@user.firstname} #{@user.lastname} created successfully!"
      redirect_to home_index_path
    else
      flash[:alert] = "Failed to create professor: #{@user.errors.full_messages.join(', ')}"
      redirect_to home_index_path
    end
  end

  def edit;
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Professor updated successfully!"
      redirect_to edit_home_path(@user)
    else
      flash[:alert] = "Failed to update professor: #{@user.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = 'Account successfully deleted.'
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
    end
    redirect_to home_index_path
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