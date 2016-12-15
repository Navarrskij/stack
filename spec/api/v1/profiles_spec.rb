require 'rails_helper'

describe 'Profile API' do
  describe 'Get/me' do
    let(:url_path) { "/api/v1/profiles/me" }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:url_path) { "/api/v1/profiles/me" }

      before { get url_path, format: :json, access_token: access_token.token }

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
    let(:url_path) { "/api/v1/profiles" }

    it_behaves_like "API Authenticable"
   

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get url_path, format: :json, access_token: access_token.token }

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