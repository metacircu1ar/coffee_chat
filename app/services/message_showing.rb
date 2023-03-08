class MessageShowing
  include ServicesHelpers
  include UnreadCountsHelper

  def show_message(user, params)
    run_result_method(:do_show_message, user, params)
  end

  private 

  def do_show_message(user, params)
    chat = yield chat_exists?(user, params[:chat_id])
    message = yield message_exists?(chat, params[:message_id])
    Ok[message_id: message.id, message_text: message.text]
  end
end