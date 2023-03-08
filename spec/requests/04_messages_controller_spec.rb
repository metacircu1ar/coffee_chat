require 'rails_helper'

describe "MessagesController", :type => :request do
  let!(:user_count) { 5 }
  let!(:message_count) { 5 }

  let!(:registering_users_data) do 
    user_count.times.map { generate_registering_user_data }
  end

  it 'successfully adds messages' do
    logged_in_users_data = registering_users_data.map { |data| register(data) ; login(data) }

    user_and_contacts_data = logged_in_users_data.map.with_index do |user, i| 
      [user, logged_in_users_data.reject.with_index { |_, j| j == i }]
    end

    user_and_contacts_data.each do |user, contacts|
      contact_ids = contacts.map { |c| c["user_id"] }
      contact_ids.each { |contact_id| post_contact(user, contact_id)}

      chat_topic = Faker::Lorem.sentence
      
      post_chat(user, chat_topic)
      
      created_chat_id = json["id"]

      all_members = [user] + contacts

      all_members.each do |member| 
        post_member(user, created_chat_id, member["user_id"])
      end
      
      get_messages(user, created_chat_id)
      expect(json["chat_id"]).to eq(created_chat_id)
      expect(json["messages"]).to eq([])
      expect(response).to have_http_status(:success)

      message_data = message_count.times.map do 
        empty_message = ""
        post_message(user, created_chat_id, empty_message)
        expect(json["status"]).to eq("Error")

        whitespace_only_message = "        "
        post_message(user, created_chat_id, whitespace_only_message)
        expect(json["status"]).to eq("Error")

        message_text = Faker::Lorem.sentence(word_count: rand(50) + 1)
        post_message(user, created_chat_id, message_text)
        expect(json["status"]).to eq("Success")
        expect(json["message_id"]).not_to eq(nil)
        expect(response).to have_http_status(:success)

        created_message_id = json["message_id"]

        get_message(user, created_chat_id, created_message_id)
        expect(json["message_id"]).to eq(created_message_id)
        expect(json["message_text"]).to eq(message_text)
        expect(response).to have_http_status(:success)

        { "message_id" => created_message_id, "message_text" => message_text }
      end 

      all_members.each do |member| 
        get_unread_count(member, created_chat_id)
        expect(json["unread_count"]).to eq(message_count)
      end

      message_ids = message_data.map { |data| data["message_id"] }

      get_messages(user, created_chat_id)
      expect(json["chat_id"]).to eq(created_chat_id)
      expect(json["messages"]).not_to eq([])
      json_message_ids = json["messages"].map { |message| message["id"] }
      expect(json_message_ids.sort).to eq(message_ids.sort)
      expect(response).to have_http_status(:success)

      contacts.each do |contact|
        message_data.each do |data|
          message_id, message_text = data["message_id"], data["message_text"]
          get_message(contact, created_chat_id, message_id)
          expect(json["message_id"]).to eq(message_id)
          expect(json["message_text"]).to eq(message_text)
          expect(response).to have_http_status(:success)
        end

        get_messages(contact, created_chat_id)
        expect(json["chat_id"]).to eq(created_chat_id)
        expect(json["messages"]).not_to eq([])
        json_message_ids = json["messages"].map { |message| message["id"] }
        expect(json_message_ids.sort).to eq(message_ids.sort)
        expect(response).to have_http_status(:success)
      end

      all_members.each do |member| 
        get_unread_count(member, created_chat_id)
        expect(json["unread_count"]).to eq(0)
      end

      new_user_data = generate_registering_user_data
      register(new_user_data)
      logged_in_new_user = login(new_user_data)
      post_contact(user, logged_in_new_user["user_id"])
      post_member(user, created_chat_id, logged_in_new_user["user_id"])
      get_unread_count(logged_in_new_user, created_chat_id)
      expect(json["unread_count"]).to eq(message_count)
    end
  end
end
