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
end