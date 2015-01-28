require 'rails_helper'

describe 'Profiles API' do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response.status).to eq 200
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', format: :json
    end
  end

  describe 'GET /profiles' do
    it_behaves_like 'API Authenticable' 

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users.first.id) }
      let(:profile) { users.last }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'return list of profiles without users.first' do
        expect(response.body).to have_json_size(2).at_path('profiles')
      end

      %w(email id).each do |attr|
        it "object contains #{attr}" do
          expect(response.body).to be_json_eql(profile.send(attr.to_sym).to_json).at_path("profiles/1/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "object does not contain #{attr}" do
          expect(response.body).to_not have_json_path("profiles/1/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', format: :json
    end
  end
end