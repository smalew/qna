require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:best_answer).required(false) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_db_column(:best_answer_id) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
