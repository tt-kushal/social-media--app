class ApplicationController < ActionController::Base
    protect_from_forgery unless: -> { request.format.json? }
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def authenticate_user!
        token = request.headers['token']&.split&.last
        if token.blank?
          render json: { error: 'Authorization token not provided or invalid' }, status: :unauthorized
          return
        end
  
        payload = JWT.decode(token, nil, false).first
    
        if payload.present? && payload['exp'].present? && payload['exp'] >= Time.now.to_i
          @current_user = User.find_by(id: payload['sub'])
        else
            render json: { error: 'token expired' }, status: :unauthorized
        end
       rescue JWT::DecodeError
        render json: { error: 'Invalid authorization token format' }, status: :unprocessable_entity
    end
    
    def current_user
       @current_user
    end
    
    private 

    def record_not_found
      render json: { error: 'Record not found' }, status: :not_found
    end
     
end
