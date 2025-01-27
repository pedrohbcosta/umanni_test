require 'rails_helper'

RSpec.describe "Admin V1 Users as :admin", type: :request do
  let!(:login_user) { create(:user) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 10) }

    context "without any params" do
      it "returns 10 users" do
        get url, headers: auth_header(login_user)
        expect(json_body.length).to eq 10
      end

      it "returns 10 first users" do
        get url, headers: auth_header(login_user)
        expected_users = users[0..9].as_json
        expect(json_body).to contain_exactly *expected_users
      end

      it "returns success status" do
        get url, headers: auth_header(login_user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context "POST /users" do
    let(:url) { "/admin/v1/users" }

    context "with valid params" do
      let(:user_params) { { user: attributes_for(:user)}.to_json }

      it "adds a new user" do
        expect do
          post url, headers: auth_header(login_user), params: user_params
        end.to change(User, :count).by(1)
      end

      it "returns last added User" do
        post url, headers: auth_header(login_user), params: user_params
        expected_users = User.last.as_json
        expect(json_body).to eq expected_users
      end

      it "returns success status" do
        post url, headers: auth_header(login_user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:user_invalid_params) do
        { user: attributes_for(:user, last_name: nil) }.to_json
      end

      it "does not add a new user" do
        expect do
          post url, headers: auth_header(login_user), params: user_invalid_params
        end.to_not change(User, :count)
      end

      it "returns an error message" do
        post url, headers: auth_header(login_user), params: user_invalid_params
        expect(json_body['errors']['fields']).to have_key('last_name')
      end

      it "returns unprocessable_entity status" do
        post url, headers: auth_header(login_user), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    context "with valid params" do
      let(:new_first_name) { 'NewName' }
      let(:user_params) { { user: { first_name: new_first_name } }.to_json }

      it "updates the user" do
        patch url, headers: auth_header(login_user), params: user_params
        user.reload
        expect(user.first_name).to eq new_first_name
      end

      it "returns updated user" do
        patch url, headers: auth_header(login_user), params: user_params
        user.reload
        expected_user = user.as_json
        expect(json_body).to eq expected_user
      end

      it "returns successful status" do
        patch url, headers: auth_header(login_user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:user_invalid_params) do
        { user: attributes_for(:user, first_name: nil) }.to_json
      end

      it "does not update the user" do
        old_first_name = user.first_name
        patch url, headers: auth_header(login_user), params: user_invalid_params
        user.reload
        expect(user.first_name).to eq old_first_name
      end

      it "returns an error message" do
        patch url, headers: auth_header(login_user), params: user_invalid_params
        expect(json_body['errors']['fields']).to have_key('first_name')
      end

      it "returns unprocessable_entity" do
        patch url, headers: auth_header(login_user), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /users/:id" do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    it "deletes the user" do
      expect do
        delete url, headers: auth_header(login_user)
      end.to change(User, :count).by(-1)
    end

    it "returns success status" do
      delete url, headers: auth_header(login_user)
      expect(response).to have_http_status(:no_content)
    end

    it "does not return any body content" do
      delete url, headers: auth_header(login_user)
      expect(json_body).to_not be_present
    end
  end
end