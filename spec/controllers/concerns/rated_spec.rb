require 'rails_helper'

shared_examples 'rated_actions' do |record_name|
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe '#PATCH rate_up' do
    shared_examples 'correct result' do
      it { expect(response.body).to eq({ record_id: record.id, difference: 1 }.to_json) }
    end

    shared_examples 'correct zero result' do
      it { expect(response.body).to eq({ record_id: record.id, difference: 0 }.to_json) }
    end

    context 'user is record owner' do
      before { login(user) }
      let!(:record) { create(record_name, user: user) }

      before { patch :rate_up, params: { id: record, format: :json } }

      include_examples 'correct zero result'
    end

    context 'user is not record owner' do
      before { login(user) }
      let!(:record) { create(record_name) }

      before { patch :rate_up, params: { id: record, format: :json } }

      include_examples 'correct result'
    end
  end

  describe '#PATCH rate_down' do
    shared_examples 'correct result' do
      it { expect(response.body).to eq({ record_id: record.id, difference: -1 }.to_json) }
    end

    shared_examples 'correct zero result' do
      it { expect(response.body).to eq({ record_id: record.id, difference: 0 }.to_json) }
    end

    context 'user is record owner' do
      before { login(user) }
      let!(:record) { create(record_name, user: user) }

      before { patch :rate_down, params: { id: record, format: :json } }

      include_examples 'correct zero result'
    end

    context 'user is not record owner' do
      before { login(user) }
      let!(:record) { create(record_name) }

      before { patch :rate_down, params: { id: record, format: :json } }

      include_examples 'correct result'
    end
  end

  describe '#PATCH cancel_rate' do
    shared_examples 'correct result' do
      it { expect(response.body).to eq({ record_id: record.id, difference: 1 }.to_json) }
    end

    shared_examples 'correct zero result' do
      it { expect(response.body).to eq({ record_id: record.id, difference: 0 }.to_json) }
    end

    context 'user is record owner' do
      before { login(user) }
      let!(:record) { create(record_name, user: user) }
      let!(:rate) { create(:rate, ratable: record, user: another_user, status: :positive) }

      before { patch :cancel_rate, params: { id: record, format: :json } }

      include_examples 'correct result'
    end

    context 'user is not record owner' do
      before { login(user) }
      let!(:record) { create(record_name) }
      let!(:rate) { create(:rate, ratable: record, user: user, status: :positive) }

      before { patch :cancel_rate, params: { id: record, format: :json } }

      include_examples 'correct zero result'
    end
  end
end
