require 'rails_helper'

describe "ContactsController", :type => :request do
  let!(:user_count) { 5 }

  let!(:registering_users_data) do 
    user_count.times.map { generate_registering_user_data }
  end

  it 'successfully adds contacts' do
    logged_in_users_data = registering_users_data.map { |data| register(data) ; login(data) }

    user_and_contacts_data = logged_in_users_data.map.with_index do |user, i| 
      [user, logged_in_users_data.reject.with_index { |_, j| j == i }]
    end
    
    user_and_contacts_data.each do |user, contacts|
      get_contacts(user)
      expect(json.size).to eq(1)
      expect(json[0]["id"]).to eq(user["user_id"])
      expect(response).to have_http_status(:success)
      
      contacts.each do |contact|
        post_contact(user, contact["user_id"])
        expect(json["status"]).to eq("Success")
        expect(response).to have_http_status(:success)
      end

      contact_ids = [user["user_id"]] + contacts.map { |c| c["user_id"] }
      
      get_contacts(user)
      expect(response).to have_http_status(:success)
      json_contact_ids = json.map { |contact| contact["id"] }
      expect(json_contact_ids.sort).to eq(contact_ids.sort)
    end
  end
end