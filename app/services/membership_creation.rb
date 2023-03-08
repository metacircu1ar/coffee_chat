class MembershipCreation
  include Monadic::Transaction
  include ServicesHelpers
  include MembershipsHelper
  include UnreadCountsHelper

  def create_membership(user, params)
    run_result_method(:do_create_membership, user, params)
  end

  private

  def do_create_membership(user, params)
    member_id, chat_id = params[:member_id], params[:chat_id]
    chat = yield chat_exists?(user, chat_id)
    number_of_messages = chat.messages.size

    run_transaction_block do
      Abort["Failed to add member"] if !add_member(user, member_id, chat_id)
      Abort["Failed to add unread count"] if !add_unread_count(member_id, chat_id, number_of_messages)

      Ok[chat_id: chat_id.to_i, member_id: member_id.to_i]
    end
  end
end
