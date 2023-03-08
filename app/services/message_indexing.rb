class MessageIndexing
  include ServicesHelpers
  include UnreadCountsHelper

  def index_messages(user, params)
    run_result_method(:do_index_messages, user, params)
  end

  private 

  def do_index_messages(user, params)
    chat_id = params[:chat_id].to_i
    chat = yield chat_exists?(user, chat_id)
    timestamp = extract_timestamp(params[:created_at_or_after])
    reset_unread_count(chat, user.id)
    messages = chat.messages.created_at_or_after(timestamp)
    Ok[chat_id: chat_id, messages: messages]
  end
end
  