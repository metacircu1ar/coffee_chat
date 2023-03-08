class ApplicationController < ActionController::Base
  attr_accessor :current_user

  def authorize
    user = User.find_by(id: params[:user_id])
    if user && user.cookie == cookies["cookie"]
      self.current_user = user
      yield
    else
      render json: {
        status: "Error",
        message: "Authorization failure"
      }, status: 401
    end
  end
end
