# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  respond_to :json

  def respond_with(resource,opt={})
      build_resource(sign_up_params)
      
      resource.save
        if resource.valid?
          handle_successfull_signup(resource)
        else
          handle_unsuccessfull_signup(resource)
        end
  end

private 

  def sign_up_params
      params.require(:user).permit(:email, :password,)
  end

  def handle_successfull_signup(resource)
    token = request.env['warden-jwt_auth.token']
    sign_up(resource_name, resource)
    response_data = {
      data: {
        id: resource.id,
        email: resource.email
      },
      meta: {
        token: token
      }, 
      message: "User created successfully"
    }
    render json: response_data, status: 201
  end
  

  def handle_unsuccessfull_signup(resource)
    render json: {
      message: "User couldn't be created .#{resource.errors.full_messages}"
    }, status: :unprocessable_entity
  end
  
  

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
