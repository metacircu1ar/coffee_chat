class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  around_action :authorize, only: [:authorized, :logout]
  include Monadic

  def authorized
    render json: {
      status: "Success",
      user_id: current_user.id
    }
  end

  def login
    result = UserLogin.new.log_in_user(login_params)
    
    case result
    when Ok
      render json: {
        status: "Success",
        user_id: result.value[:user_id],
        cookie: result.value[:cookie]
      }
    when Error
      render json: {
        status: "Error",
        message: result.error
      }, status: 401
    end
  end

  def register
    result = UserRegistration.new.register_user(register_params)
    
    case result
    when Ok
      render json: {
        status: "Success",
        user_id: result.value[:user_id]
      }
    when Error
      render json: {
        status: "Error",
        message: result.error
      }, status: 401
    end
  end

  def logout
    current_user.update_attribute(:cookie, nil)

    render json: {
      status: "Success",
      user_id: current_user.id
    }
  end

  def login_params
    params.permit(:email, :password)
  end

  def logout_params
    params.permit(:user_id, :cookie)
  end

  def register_params
    params.permit(:email, :name, :password)
  end
end
