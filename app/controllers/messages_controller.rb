class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  around_action :authorize, only: [:index, :create, :show]
  include Monadic
  include Utils

  def index
    result = MessageIndexing.new.index_messages(current_user, index_params)
    
    case result
    when Ok
      render json: { 
        status: "Success",
        chat_id: result.value[:chat_id],
        messages: result.value[:messages].map { |message| 
          {
            id: message.id,
            user_id: message.user_id,
            user_name: message.user.name,
            text: message.text,
            created_at_unixtime: to_millisec(message.created_at),
            created_at_timestamp: message.created_at.to_s
          }
        }
      }
    when Error
      render json: { 
        status: "Error",
        message: result.error 
      }
    end
  end

  def create
    result = MessageCreation.new.create_message(current_user, create_params)
    
    case result
    when Ok
      render json: { 
        status: "Success", 
        message_id: result.value[:message_id],
        created_at_unixtime: result.value[:created_at_unixtime]
      }
    when Error
      render json: { 
        status: "Error", 
        message: result.error 
      }
    end
  end

  def show
    result = MessageShowing.new.show_message(current_user, show_params)
    
    case result
    when Ok
      render json: { 
        status: "Success",
        message_id: result.value[:message_id],
        message_text: result.value[:message_text]
      }
    when Error
      render json: { 
        status: "Error",
        message: result.error 
      }
    end
  end

  def index_params
    params.permit(:chat_id, :created_at_or_after)
  end

  def create_params
    params.permit(:user_id, :chat_id, :message_text)
  end

  def show_params
    params.permit(:chat_id, :message_id)
  end
end
