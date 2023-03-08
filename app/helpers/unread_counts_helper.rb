module UnreadCountsHelper
  def add_unread_count(member_id, chat_id, initial_count = 0)
    member = User.find_by(id: member_id)
    chat = member&.chats.find_by(id: chat_id)
    if member && chat
      if !chat.unread_counts.find_by(user: member)
        unread_count = chat.unread_counts.build(user: member, count: initial_count)
        return unread_count.save
      else 
        true
      end
    else 
      false
    end
  end

  def increment_unread_count(chat, member_id)
    chat.unread_counts.where(user_id: member_id).update_all("count = count + 1")
  end

  def reset_unread_count(chat, member_id)
    chat.unread_counts.where(user_id: member_id).update_all("count = 0")
  end
end