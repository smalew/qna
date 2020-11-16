# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'associations' do
    it { should have_one(:regard).dependent(:destroy) }
    it { should accept_nested_attributes_for :regard }

    it_behaves_like 'has_user'
    it_behaves_like 'answerable'
    it_behaves_like 'filable'
    it_behaves_like 'linkable'
    it_behaves_like 'commentable'
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
