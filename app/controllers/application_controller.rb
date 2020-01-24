class ApplicationController < ActionController::API
  include Pundit
  include ActionController::MimeResponds
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private
    def user_not_authorized
      render json: { error: "Access Denied"}, status: :forbidden
    end
end
