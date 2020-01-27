class ApplicationController < ActionController::API
  include Pundit
  include ActionController::MimeResponds
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private

    # def respond_with_errors(object)
    #   render json: {errors: ErrorSerializer.serialize(object)}, status: :unprocessable_entity
    # end
    
    def user_not_authorized
      render json: { error: "Access Denied"}, status: :forbidden
    end
end
