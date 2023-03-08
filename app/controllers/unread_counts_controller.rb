class UnreadCountsController < ApplicationController
  around_action :authorize, only: [:show]
  include Monadic

  def show
    result = UnreadCountShowing.new.show_unread_count(current_user, show_params)
    
    case result      
    when Ok
      render json: { 
        status: "Success",
        id: result.value[:id],
        unread_count: result.value[:unread_count]
      }
    when Error
      render json: { 
        status: "Error",
        message: result.error 
      }
    end    
  end

  def show_params
    params.permit(:chat_id)
  end
end