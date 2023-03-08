module ApiHelpers
  JSON_HEADERS = { 'Content-Type' => 'application/json' }

  def generate_registering_user_data
    {
      "name" => Faker::Name.first_name,
      "email" => Faker::Internet.email,
      "password" => Faker::Internet.password
    }
  end
  
  def register(user_data)
    post '/auth/register', params: user_data.to_json, headers: JSON_HEADERS
    json
  end

  def login(user_data)
    route = "/auth/login"
    post route, params: user_data.to_json, headers: JSON_HEADERS
    { "user_id" => json["user_id"], "cookie" => json["cookie"]}
  end

  def logout(user_data)
    route = "/auth/logout/#{user_data["user_id"]}"
    cookies["cookie"] = user_data["cookie"]
    post route
  end
 
  def authorized(user_data)
    route = "/auth/authorized/#{user_data["user_id"]}"
    cookies["cookie"] = user_data["cookie"]
    post route
    json
  end

  def get_contacts(user_data)
    cookies["cookie"] = user_data["cookie"]
    get "/users/#{user_data["user_id"]}/contacts"
  end

  def post_contact(user_data, contactee_id)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/contacts/#{contactee_id}"
    post route
  end

  def get_chats(user_data)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats"
    get route
  end
  
  def get_chat(user_data, chat_id)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats/#{chat_id}"
    get route
  end

  def post_chat(user_data, chat_topic)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats"
    params = { chat_topic: chat_topic }
    post route, params: params, headers: JSON_HEADERS, as: :json
  end

  def post_chat_with_members(user_data, chat_topic, member_ids)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats"
    params = { chat_topic: chat_topic, member_ids: member_ids }
    post route, params: params, headers: JSON_HEADERS, as: :json
  end

  def get_messages(user_data, chat_id)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats/#{chat_id}/messages"
    get route
  end

  def get_message(user_data, chat_id, message_id)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats/#{chat_id}/messages/#{message_id}"
    get route
  end

  def post_message(user_data, chat_id, message_text)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats/#{chat_id}/messages"
    params = { message_text: message_text }
    post route, params: params
  end
  
  def get_members(user_data, chat_id)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats/#{chat_id}/members"
    get route
  end

  def post_member(user_data, chat_id, member_id)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats/#{chat_id}/members/#{member_id}"
    post route
  end

  def get_unread_count(user_data, chat_id)
    cookies["cookie"] = user_data["cookie"]
    route = "/users/#{user_data["user_id"]}/chats/#{chat_id}/unread_count"
    get route
  end

  def json
    JSON.parse(response.body)
  end
end
