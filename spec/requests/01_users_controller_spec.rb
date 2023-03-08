require 'rails_helper'

describe "UsersController", :type => :request do
  let!(:user_count) { 3 }

  it 'successfully registers users' do
    user_count.times.each do
      user_data = generate_registering_user_data
      register(user_data)
      expect(json["status"]).to eq("Success")
      expect(response).to have_http_status(:success)
    end
    expect(User.count).to eq(user_count)
  end

  it 'registers unsuccessfully' do
    user_count.times.each do
      user_data = { name: "aaa", email: "a@b.com", password: "   a"}
      register(user_data)
      expect(json["status"]).to eq("Error")
      expect(response).to have_http_status(401)

      user_data = { name: "aaa", email: "a@b.com", password: "   "}
      register(user_data)
      expect(json["status"]).to eq("Error")
      expect(response).to have_http_status(401)
    end
  end

  it 'rejects already registered users' do
    user_count.times.each do
      user_data = generate_registering_user_data
      register(user_data)
      register(user_data)
      expect(json["status"]).to eq("Error")
      expect(response).to have_http_status(401)
    end
    expect(User.count).to eq(user_count)
  end

  it 'logs in successfully' do
    user_count.times.each do
      user_data = generate_registering_user_data
      register(user_data)
      login_response = login(user_data)
      expect(json["status"]).to eq("Success")
      expect(response).to have_http_status(:success)
      expect(User.find_by(id: json["user_id"]).cookie).to eq(json["cookie"])

      authorized(login_response)
      expect(json["status"]).to eq("Success")
      expect(response).to have_http_status(:success)
    end
  end

  it 'logs in unsuccessfully' do
    user_count.times.each do
      user_data = generate_registering_user_data
      register(user_data)
      login_response = login({ email: user_data["email"], password: ""})
      expect(json["status"]).to eq("Error")
      expect(response).to have_http_status(401)
    end
  end

  it 'logs out successfully' do
    user_count.times.each do
      user_data = generate_registering_user_data
      register(user_data)
      login_response = login(user_data)
      logout(login_response)
      expect(response).to have_http_status(:success)
      expect(json["status"]).to eq("Success")
      expect(User.find_by(id: login_response["user_id"]).cookie).to eq(nil)

      authorized(login_response)
      expect(json["status"]).to eq("Error")
      expect(response).to have_http_status(401)
    end
  end

  it 'logs out unsuccessfully' do
    user_count.times.each do
      user_data = generate_registering_user_data
      register(user_data)
      login_response = login(user_data)
      logout({ "user_id" => login_response["user_id"], "cookie" => "" })
      expect(response).to have_http_status(401)
      expect(json["status"]).to eq("Error")
      expect(User.find_by(id: login_response["user_id"]).cookie).to eq(login_response["cookie"])
      authorized(login_response)
      expect(json["status"]).to eq("Success")
      expect(response).to have_http_status(:success)
    end
  end
end