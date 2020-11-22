# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:question) { create(:question) }

  shared_examples 'Checking incorrect params' do
    context 'with invalid attributes' do
      context 'when body empty' do
        let(:record_params) { attributes_for(:answer, :empty_body) }

        include_examples 'API incorrect response'
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      let!(:records) { create_list(:answer, 3, question: question) }

      let(:record) { records.first }
      let(:record_response) { json['answers'].first }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      include_examples 'API correct response'
      include_examples 'API fields checking', %w[id body best_answer user_id created_at updated_at]

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns short_body field' do
        expect(record_response['short_body']).to eq record.body.truncate(10)
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:record) { create(:answer, question: question) }
    let(:record_response) { json['answer'] }

    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{record.id}" }

    let!(:comments) { create_list(:comment, 2, commentable: record) }
    let!(:links) { create_list(:link, 2, linkable: record) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      include_examples 'API correct response'
      include_examples 'API fields checking', %w[id body best_answer user_id created_at updated_at]
      include_examples 'API Comments checking'
      include_examples 'API Files checking'
      include_examples 'API Links checking'
    end
  end

  describe '#POST /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    before do
      do_request(method, api_path,
                 params: { access_token: access_token.token, answer: record_params },
                 headers: headers)
    end

    include_examples 'Checking incorrect params'

    context 'with valid attributes' do
      let(:record_params) do
        {
          body: 'Answer body',
          links_attributes: [
            { name: 'Link1', url: 'http://test1.com' },
            { name: 'Link2', url: 'http://test2.com' }
          ]
        }
      end
      let(:record) { Answer.last }
      let(:links) { record.links }

      let(:record_response) { json['answer'] }

      include_examples 'API correct response'
      include_examples 'API fields checking', %w[id body user_id created_at]
      include_examples 'API Author checking'

      it { expect(links.size).to eq(2) }
      include_examples 'API Links checking'
    end
  end

  describe '#PUT /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let!(:record) { create(:answer, question: question, user: user) }
    let(:links) { record.links }

    let(:method) { :put }
    let(:api_path) { "/api/v1/answers/#{record.id}" }

    before do
      do_request(method, api_path,
                 params: { access_token: access_token.token, answer: record_params },
                 headers: headers)
    end

    context 'when user is answer owner' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      include_examples 'Checking incorrect params'

      context 'with valid attributes' do
        let(:record_params) do
          {
            body: 'Updated answer body'
          }
        end
        let(:record_response) { json['answer'] }

        include_examples 'API correct response'
        include_examples 'API Author checking'
        include_examples 'API updated fields checking', {
          body: 'Updated answer body'
        }.stringify_keys
      end
    end

    context 'when user is not question owner' do
      let(:access_token) { create(:access_token, resource_owner_id: another_user.id) }
      include_examples 'Checking incorrect params'

      context 'with valid attributes' do
        let(:record_params) do
          { body: 'Updated Answer body' }
        end

        include_examples 'API incorrect response'
        it { expect(record.reload.body).to_not eq('Updated Answer body') }
      end
    end
  end

  describe '#DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let!(:record) { create(:answer, question: question, user: user) }

    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{record.id}" }

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
