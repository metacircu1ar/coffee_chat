require 'rails_helper'

describe "ChatsController, MembershipsController", :type => :request do
  let!(:user_count) { 5 }

  let!(:registering_users_data) do 
    user_count.times.map { generate_registering_user_data }
  end

  it 'successfully adds chats' do
    logged_in_users_data = registering_users_data.map { |data| register(data) ; login(data) }

    logged_in_users_data.each do |user|
      get_chats(user)
      expect(json).to eq([])
      expect(response).to have_http_status(:success)
    end

    user_and_contacts_data = logged_in_users_data.map.with_index do |user, i| 
      [user, logged_in_users_data.reject.with_index { |_, j| j == i }]
    end

    user_and_contacts_data.each do |user, contacts|
      user_id = user["user_id"]
      contact_ids = contacts.map { |c| c["user_id"] }
      contact_ids.each { |contact_id| post_contact(user, contact_id)}

      all_member_ids = [user_id] + contact_ids

      empty_chat_topic = ""
      post_chat_with_members(user, empty_chat_topic, all_member_ids)
      expect(json["status"]).to eq("Error")

      whitespace_only_topic = "              "
      post_chat_with_members(user, whitespace_only_topic, all_member_ids)
      expect(json["status"]).to eq("Error")

      chat_topic = Faker::Lorem.sentence(word_count: rand(50) + 1)      
      post_chat_with_members(user, chat_topic, all_member_ids) 
      expect(json["status"]).to eq("Success")
      expect(json["id"]).not_to eq(nil)
      expect(response).to have_http_status(:success)
      
      created_chat_id = json["id"].to_i

      get_members(user, created_chat_id)
      expect(json["chat_id"]).to eq(created_chat_id)
      expect(json["member_ids"].sort).to eq(all_member_ids.sort)
      expect(response).to have_http_status(:success)

      all_members = [user] + contacts
      all_members.each do |member| 
        get_members(member, created_chat_id)
        expect(json["chat_id"]).to eq(created_chat_id)
        expect(json["member_ids"].sort).to eq(all_member_ids.sort)
        expect(response).to have_http_status(:success)

        get_chat(member, created_chat_id)
        expect(json["user_id"]).to eq(user_id)
        expect(json["topic"]).to eq(chat_topic)
        expect(json["id"]).to eq(created_chat_id)
        expect(response).to have_http_status(:success)

        get_unread_count(member, created_chat_id)
        expect(json["unread_count"]).to eq(0)
      end
    end
  end
end