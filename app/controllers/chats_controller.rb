class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token
  around_action :authorize, only: [:index, :create, :show, :unread_count]
  include Utils
  include Monadic
  
  def index
    timestamp = extract_timestamp(index_params[:created_at_or_after])
    chats = current_user.chats.created_at_or_after(timestamp)
    response = chats.map do |chat|
      { 
        id: chat.id,
        topic: chat.topic,
        user_id: chat.user.id,
        created_at_unixtime: chat.created_at.to_i
      }
    end
    render json: response
  end

  def create
    result = ChatCreation.new.create_chat(current_user, params)
    
    case result
    when Ok
      render json: { 
        status: "Success", 
        id: result.value[:chat_id] 
      }
    when Error
      render json: { 
        status: "Error", 
        message: result.error 
      }
    end
  end

  def show
    chat = current_user.chats.find_by(id: show_params[:chat_id]) 
    if chat
      render json: {
        status: "Success",
        id: chat.id,
        topic: chat.topic,
        user_id: chat.user.id,
        created_at_unixtime: chat.created_at.to_i     
      }
    else
      render json: {
        status: "Error"
      }
    end
  end

  def index_params
    params.permit(:created_at_or_after)
  end

  def create_params
    params.permit(:chat_topic, member_ids: [])
  end

  def show_params
    params.permit(:chat_id)
  end
end
