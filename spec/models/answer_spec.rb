require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
    it { should have_db_column(:question_id) }
  end

  context 'scopes' do
    describe '#casual' do
      let!(:answers) { create_list(:answer, 3) }

      context 'without best answer' do
        it {expect(Answer.casual).to match_array(answers)}
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, best_answer: true) }

        it {expect(Answer.casual).to match_array(answers)}
      end
    end

    describe '#best' do
      let!(:answers) { create_list(:answer, 3) }

      context 'without best answer' do
        it {expect(Answer.best).to match_array([])}
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, best_answer: true) }

        it {expect(Answer.best).to match_array([best_answer])}
      end
    end
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
  end
end
