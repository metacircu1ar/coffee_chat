class MembershipsController < ApplicationController
  skip_before_action :verify_authenticity_token
  around_action :authorize, only: [:index, :create]
  include Monadic
  
  def index
    chat = current_user.chats.find_by(id: params[:chat_id])
    
    if chat
      render json: {
        status: "Success",
        chat_id: chat.id,
        member_ids: chat.users.pluck(:id)
      }
    else
      render json: {
        status: "Error"
      }, status: 401
    end
  end

  def create
    result = MembershipCreation.new.create_membership(current_user, create_params)
    
    case result
    when Ok
      render json: {
        status: "Success",
        chat_id: result.value[:chat_id],
        member_id: result.value[:member_id]
      }
    when Error
      render json: {
        status: "Error",
        message: result.error
      }
    end
  end

  def index_params
    params.permit(:chat_id)
  end

  def create_params
    params.permit(:chat_id, :member_id)
  end
end
  