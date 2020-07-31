require 'rails_helper'

RSpec.describe Rate, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:ratable) }

    it { should have_db_column(:ratable_id) }
  end

  context 'scopes' do
    describe '#positives' do
      context 'when has no positives ' do
        let!(:rate) { create(:rate) }

        it { expect(Rate.positives.count).to eq(0) }
      end

      context 'when positives present' do
        let!(:rate) { create(:rate, positive: true) }

        it { expect(Rate.positives.count).to eq(1) }
        it { expect(Rate.positives).to eq([rate]) }
      end
    end
  end

  describe '#negatives' do
    context 'when has no negatives' do
      let!(:rate) { create(:rate) }

      it { expect(Rate.negatives.count).to eq(0) }
    end

    context 'when positives present' do
      let!(:rate) { create(:rate, negative: true) }

      it { expect(Rate.negatives.count).to eq(1) }
      it { expect(Rate.negatives).to eq([rate]) }
    end
  end
end
