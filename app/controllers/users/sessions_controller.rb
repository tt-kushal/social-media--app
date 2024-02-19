# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]


  def respond_with(resource, _opts = {})
    token = request.env['warden-jwt_auth.token']
    @user = User.find_by(email: params[:user][:email])
    
    if @user && @user.profile.present?
      if @user.valid_password?(params[:user][:password]) 
        sign_in @user
          response_data = {
            message: "User logged In successfully",
            data: {
              email: @user.email,
              user_id: @user.id,
              profile_id: @user.profile.id  
            },
            meta: {
              token: token
            } 
          }
          render json: response_data
      else
        render json: {message: "Incorrect email or password"}, status: 404
      end
    else
        render json: {  message: 'Create a profile',
                      token: token
                  }, status: :not_found
    end
  end

  
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
