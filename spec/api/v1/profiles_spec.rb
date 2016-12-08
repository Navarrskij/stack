require 'rails_helper'

describe 'Profile API' do
  describe 'Get/me' do
    context 'unauthorized' do
      it 'renurn 410 status if there is not access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'renurn 410 status if there access_token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '112332'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'get/index' do
    context 'unauthorized' do
      it 'renurn 410 status if there is not access_token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it 'renurn 410 status if there access_token is invalid' do
        get '/api/v1/profiles', format: :json, access_token: '112332'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'return all users' do
        expect(response.body).to have_json_size(3)
      end

      it 'does not contains me' do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains users #{attr}" do
          users.each.with_index(0) do |user, a|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{a}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains users #{attr}" do
          users.each_index do |a|
            expect(response.body).to_not have_json_path("#{a}/#{attr}")
          end
        end
      end
    end
  end
end