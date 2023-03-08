module ServicesHelpers
  include Utils
  include Monadic::Result

  def chat_exists?(user, chat_id)
    chat = user.chats.find_by(id: chat_id) 
    return Error["Chat doesn't exist"] if chat.nil?
    Ok[chat]
  end
  
  def message_exists?(chat, message_id)
    message = chat.messages.find_by(id: message_id) 
    return Error["Message doesn't exist"] if message.nil?
    Ok[message]
  end

  def unread_count_exists?(chat, user_id)
    unread_count = chat.unread_counts.find_by(user_id: user_id)
    return Error["Unread count doesn't exist"] if unread_count.nil?
    Ok[unread_count]
  end

  def user_exists_by_email?(email)
    user = User.find_by(email: email)
    return Error["User doesn't exist"] if user.nil?
    Ok[user]
  end

  def is_user_password_correct?(user, password)
    return Ok[password] if user.password == password
    Error["Incorrect password"]
  end
end