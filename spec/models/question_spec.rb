require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:answers).dependent(:destroy) }
    it { expect(build(:question).files).to be_instance_of(ActiveStorage::Attached::Many) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  context 'methods' do
    describe '#best_answer' do
      let(:question) { create(:question) }

      context 'with best answer' do
        let!(:first_answer) { create(:answer, question: question, best_answer: false) }
        let!(:second_answer) { create(:answer, question: question, best_answer: true) }

        it { expect(question.reload.best_answer).to eq(second_answer) }
      end

      context 'without best answer' do
        let!(:first_answer) { create(:answer, question: question, best_answer: false) }
        let!(:second_answer) { create(:answer, question: question, best_answer: false) }

        it { expect(question.reload.best_answer).to eq(nil) }
      end

      context 'without answers' do
        it { expect(question.reload.best_answer).to eq(nil) }
      end
    end
  end
end
