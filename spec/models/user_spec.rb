require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  context 'methods' do
    describe '#author_of?' do
      let(:user) { create(:user) }
      let (:question) { create(:question, user: owner) }
      let (:answer) { create(:answer, user: owner) }

      context 'when user is owner for' do
        let!(:owner) { user }

        context 'question' do
          it { expect(user.author_of?(question)).to be_truthy }
        end

        context 'answer' do
          it { expect(user.author_of?(answer)).to be_truthy }
        end
      end

      context 'when user is not owner for' do
        let!(:owner) { create(:user) }

        context 'question' do
          it { expect(user.author_of?(question)).to be_falsey }
        end

        context "answer" do
          it { expect(user.author_of?(answer)).to be_falsey }
        end
      end
    end
  end
end
