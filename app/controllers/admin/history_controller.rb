class Admin::HistoryController < AdminApplicationController
  def index
  end

  def professor
    if params[:encrypted_params].present?
      begin
        decrypted_params = Rack::Utils.parse_nested_query(EncryptionHelper.decrypt(params[:encrypted_params]))
        params.merge!(decrypted_params)
      rescue => e
        Rails.logger.error "Error decrypting parameters: #{e.message}"
        flash[:error] = "Invalid parameters."
        redirect_to history_professor_path and return
      end
    end

    users_query = User.where(remarks: 'archived').order(:firstname)

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
        pdf = ProfessorHistoryPdf.new(users_query)
        send_data pdf.render,
                  filename: "professor_history.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  def card
  end

  def room
  end

  def schedule
  end
end
