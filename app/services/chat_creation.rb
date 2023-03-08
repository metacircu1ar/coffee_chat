class ChatCreation
  include Monadic::Transaction
  include Monadic::Result
  include MembershipsHelper
  include UnreadCountsHelper

  def create_chat(current_user, params)
    run_result_method(:do_create, current_user, params)
  end

  private 

  def do_create(current_user, params)
    member_ids = yield all_chat_members_are_in_contact_list?(current_user, params)
    run_transaction_block do
      chat = current_user.owned_chats.build(topic: params[:chat_topic])
      Abort[chat.errors.full_messages] if !chat.save
      member_ids.each do |member_id| 
        Abort["Failed to add member "] if !add_member(current_user, member_id, chat.id) 
        Abort["Failed to add unread count"] if !add_unread_count(member_id, chat.id)
      end
      Ok[chat_id: chat.id]
    end
  end

  def all_chat_members_are_in_contact_list?(current_user, params)
    member_ids = (params[:member_ids] || []) + [current_user.id]
    member_ids = member_ids.to_set
    contact_ids = current_user.contacts.pluck(:id).to_set
    return Ok[member_ids] if member_ids.subset?(contact_ids)
    Error["Not all members are in contact list"]
  end
end
