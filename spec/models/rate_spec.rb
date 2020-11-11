# == Schema Information
#
# Table name: rates
#
#  id           :bigint           not null, primary key
#  user_id      :bigint
#  ratable_type :string
#  ratable_id   :bigint
#  status       :integer          default("positive"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Rate, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:ratable) }

    it { should have_db_column(:ratable_id) }
    it { should have_db_column(:user_id) }
  end

  context 'validations' do
    it { should define_enum_for(:status).with_values(negative: -1, positive: 1).backed_by_column_of_type(:integer) }
  end

  context 'scopes' do
    describe '#positives' do
      context 'when has no positives ' do
        let!(:rate) { create(:rate) }

        it { expect(Rate.positive.count).to eq(0) }
      end

      context 'when positives present' do
        let!(:rate) { create(:rate, status: :positive) }

        it { expect(Rate.positives.count).to eq(1) }
        it { expect(rate.positive?).to be_truthy }
      end
    end
  end

  describe '#negatives' do
    context 'when has no negatives' do
      let!(:rate) { create(:rate, status: :positive) }

      it { expect(Rate.negative.count).to eq(0) }
    end

    context 'when positives present' do
      let!(:rate) { create(:rate, status: :negative) }

      it { expect(Rate.negatives.count).to eq(1) }
      it { expect(rate.negative?).to be_truthy }
    end
  end
end
