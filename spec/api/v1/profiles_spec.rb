require 'rails_helper'

describe 'Profiles APLI', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:record) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: record.id) }
      let(:record_response) { json['user'] }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      include_examples 'API correct response'
      include_examples 'API fields checking', %w[id email admin created_at updated_at]

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:record) { create(:user) }
      let!(:another_records) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: record.id) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      include_examples 'API correct response'

      it 'returns all users' do
        expect(json['users'].size).to eq(3)
        expect(json['users']).
          to match_array(another_records.map { |record| UserSerializer.new(record).as_json.deep_stringify_keys })
      end
    end
  end
end
