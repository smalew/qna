require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  shared_examples 'Checking incorrect params' do
    context 'with invalid attributes' do
      context 'when title empty' do
        let(:record_params) { attributes_for(:question, :empty_title) }

        include_examples 'API incorrect response'
      end

      context 'when body empty' do
        let(:record_params) { attributes_for(:question, :empty_body) }

        include_examples 'API incorrect response'
      end
    end
  end

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      let(:record) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: record) }

      let(:another_record) { create(:question) }

      let!(:questions) { [record, another_record] }

      let(:record_response) { json['questions'].first }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      include_examples 'API correct response'
      include_examples 'API fields checking', %w[id title body created_at updated_at]

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'contains user object' do
        expect(record_response['user']['id']).to eq record.user.id
      end

      it 'contains short title' do
        expect(record_response['short_title']).to eq record.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { record_response['answers'].first }

        it 'returns list of answers' do
          expect(record_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:record) { create(:question, :with_files) }
    let(:record_response) { json['question'] }

    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{record.id}" }

    let!(:comments) { create_list(:comment, 2, commentable: record) }
    let!(:links) { create_list(:link, 2, linkable: record) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      include_examples 'API correct response'
      include_examples 'API fields checking', %w[id title body user_id created_at]
      include_examples 'API Comments checking'
      include_examples 'API Files checking'
      include_examples 'API Links checking'
    end
  end

  describe '#POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    let(:method) { :post }
    let(:api_path) { "/api/v1/questions" }

    before do
      do_request(method, api_path,
                 params: { access_token: access_token.token, question: record_params },
                 headers: headers)
    end

    include_examples 'Checking incorrect params'

    context 'with valid attributes' do
      let(:record_params) do
        {
          title: 'Question title',
          body: 'Question body',
          links_attributes: [
            { name: 'Link1', url: 'http://test1.com' },
            { name: 'Link2', url: 'http://test2.com' },
          ]
        }
      end
      let(:record) { Question.last }
      let(:links) { record.links }

      let(:record_response) { json['question'] }

      include_examples 'API correct response'
      include_examples 'API fields checking', %w[id title body user_id created_at]
      include_examples 'API Author checking'

      it { expect(links.size).to eq(2) }
      include_examples 'API Links checking'
    end


  end

  describe '#PUT /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let!(:record) { create(:question, user: user) }
    let(:links) { record.links }

    let(:method) { :put }
    let(:api_path) { "/api/v1/questions/#{record.id}" }

    before do
      do_request(method, api_path,
                 params: { access_token: access_token.token, question: record_params },
                 headers: headers)
    end

    context 'when user is question owner' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      include_examples 'Checking incorrect params'

      context 'with valid attributes' do
        let(:record_params) do
          {
            title: 'Updated Question title',
            body: 'Updated Question body',
          }
        end
        let(:record_response) { json['question'] }

        include_examples 'API correct response'
        include_examples 'API Author checking'
        include_examples 'API updated fields checking', {
          title: 'Updated Question title', body: 'Updated Question body'
        }.stringify_keys
      end
    end

    context 'when user is not question owner' do
      let(:access_token) { create(:access_token, resource_owner_id: another_user.id) }
      include_examples 'Checking incorrect params'

      context 'with valid attributes' do
        let(:record_params) do
          {
            title: 'Updated Question title',
            body: 'Updated Question body',
          }
        end

        include_examples 'API incorrect response'
        it { expect(record.reload.title).to_not eq('Updated Question title')}
        it { expect(record.reload.body).to_not eq('Updated Question body')}
      end
    end
  end

  describe '#DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let!(:record) { create(:question, user: user) }

    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{record.id}" }

    before do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    end

    context 'when user is question owner' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      include_examples 'API correct response'
    end

    context 'when user is not question owner' do
      let(:access_token) { create(:access_token, resource_owner_id: another_user.id) }

      include_examples 'API incorrect response'
    end
  end
end
