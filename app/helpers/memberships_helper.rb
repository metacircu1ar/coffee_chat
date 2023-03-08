module MembershipsHelper
  def add_member(chat_owner, member_id, chat_id)
    chat = chat_owner.owned_chats.find_by(id: chat_id)
    member = User.find_by(id: member_id)
    if member && chat
      if !chat.memberships.find_by(user: member)
        membership = chat.memberships.build(user: member)
        return membership.save
      else
        true
      end
    else 
      false
    end
  end
end