require 'rails_helper'

shared_examples 'ratable' do
  context 'associations' do
    it { should have_many(:rates).dependent(:destroy) }
  end

  context 'methods' do
    let(:user) { create(:user) }
    let!(:record) { create(described_class.name.underscore.to_sym, user: author) }

    describe '#rate_up_by!' do
      let(:author) { create(:user) }

      context 'without rates' do
        subject { record.rate_up_by!(user) }

        it { expect { subject }.to change(Rate, :count).by(1) }

        it { subject; expect(record.reload.rates.positives.count).to eq(1) }
        it { subject; expect(record.reload.rates.negatives.count).to eq(0) }
      end

      context 'with positive rate' do
        let!(:rate) { create(:rate, ratable: record, user: user, status: :positive) }

        subject { record.rate_up_by!(user) }

        it { expect { subject }.to_not change(Rate, :count) }

        it { subject; expect(rate.reload.positive?).to be_truthy }
        it { subject; expect(rate.reload.negative?).to be_falsey }
      end

      context 'with negative rate' do
        let!(:rate) { create(:rate, ratable: record, user: user, status: :negative) }

        subject { record.rate_up_by!(user) }

        it { expect { subject }.to_not change(Rate, :count) }

        it { subject; expect(rate.reload.positive?).to be_truthy }
        it { subject; expect(rate.reload.negative?).to be_falsey }
      end
    end

    describe '#rate_down_by!' do
      let(:author) { create(:user) }

      context 'without rates' do
        subject { record.rate_down_by!(user) }

        it { expect { subject }.to change(Rate, :count).by(1) }

        it { subject; expect(record.reload.rates.positives.count).to eq(0) }
        it { subject; expect(record.reload.rates.negatives.count).to eq(1) }
      end

      context 'with positive rate' do
        let!(:rate) { create(:rate, ratable: record, user: user, status: :positive) }

        subject { record.rate_down_by!(user) }

        it { expect { subject }.to_not change(Rate, :count) }

        it { subject; expect(rate.reload.positive?).to be_falsey }
        it { subject; expect(rate.reload.negative?).to be_truthy }
      end

      context 'with negative rate' do
        let!(:rate) { create(:rate, ratable: record, user: user, status: :negative) }

        subject { record.rate_down_by!(user) }

        it { expect { subject }.to_not change(Rate, :count) }

        it { subject; expect(rate.reload.positive?).to be_falsey }
        it { subject; expect(rate.reload.negative?).to be_truthy }
      end
    end

    describe '#cancel_rate_for!' do
      let(:author) { create(:user) }

      context 'without rates' do
        subject { record.cancel_rate_for!(user) }

        it { expect { subject }.to_not change(Rate, :count) }

        it { subject; expect(record.reload.rates.positives.count).to eq(0) }
        it { subject; expect(record.reload.rates.negatives.count).to eq(0) }
      end

      context 'with positive rate' do
        let!(:rate) { create(:rate, ratable: record, user: user, status: :positive) }

        subject { record.cancel_rate_for!(user) }

        it { expect { subject }.to change(Rate, :count).by(-1) }

        it { subject; expect(record.reload.rates.positives.count).to eq(0) }
        it { subject; expect(record.reload.rates.negatives.count).to eq(0) }
      end

      context 'with negative rate' do
        let!(:rate) { create(:rate, ratable: record, user: user, status: :negative) }

        subject { record.rate_down_by!(user) }

        subject { record.cancel_rate_for!(user) }

        it { expect { subject }.to change(Rate, :count).by(-1) }

        it { subject; expect(record.reload.rates.positives.count).to eq(0) }
        it { subject; expect(record.reload.rates.negatives.count).to eq(0) }
      end
    end

    describe '#difference_in_rates' do
      let!(:record) { create(described_class.name.underscore.to_sym) }

      context 'when positives more than negatives' do
        let!(:positive_rates) { create_list(:rate, 5, ratable: record, user: user, status: :positive) }
        let!(:negative_rates) { create_list(:rate, 3, ratable: record, user: user, status: :negative) }

        it { expect(record.difference_in_rates).to eq(2) }
      end

      context 'when positives less than negatives' do
        let!(:positive_rates) { create_list(:rate, 1, ratable: record, user: user, status: :positive) }
        let!(:negative_rates) { create_list(:rate, 4, ratable: record, user: user, status: :negative) }

        it { expect(record.difference_in_rates).to eq(-3) }
      end
    end
  end
end
