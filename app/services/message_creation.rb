class MessageCreation
  include Monadic::Transaction
  include ServicesHelpers
  include UnreadCountsHelper

  def create_message(user, params)
    run_result_method(:do_create, user, params)
  end

  private 

  def do_create(user, params)
    chat = yield chat_exists?(user, params[:chat_id])

    run_transaction_block do
      message = chat.messages.build(
        user_id: params[:user_id], 
        text: params[:message_text]
      )

      Abort[message.errors.full_messages] if !message.save

      chat.memberships.each do |membership|
        Abort["Failed to increment unread count"] if !increment_unread_count(chat, membership.user_id)
      end

      Ok[message_id: message.id, created_at_unixtime: message.created_at.to_i]
    end
  end
end
