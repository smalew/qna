require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
    it { should have_db_column(:question_id) }
  end

  context 'scopes' do
    describe '#ordered_by_best' do
      let!(:answers) { create_list(:answer, 3) }

      context 'without best answer' do
        it { expect(Answer.ordered_by_best).to match_array(answers) }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, best_answer: true) }

        it { expect(Answer.ordered_by_best).to match_array([best_answer] + answers) }
      end
    end

    describe '#casual' do
      let!(:answers) { create_list(:answer, 3) }

      context 'without best answer' do
        it { expect(Answer.casual).to match_array(answers) }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, best_answer: true) }

        it { expect(Answer.casual).to match_array(answers) }
      end
    end

    describe '#best' do
      let!(:answers) { create_list(:answer, 3) }

      context 'without best answer' do
        it { expect(Answer.best).to match_array([]) }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, best_answer: true) }

        it { expect(Answer.best).to match_array([best_answer]) }
      end
    end
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
  end

  context 'methods' do
    describe '#choose_as_best' do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:another_answer) { create(:answer, question: question, best_answer: true) }

      before { answer.choose_as_best }

      it { expect(answer.reload.best_answer).to be_truthy }
      it { expect(another_answer.reload.best_answer).to be_falsey }
    end
  end
end
