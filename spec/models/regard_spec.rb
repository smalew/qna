require 'rails_helper'

RSpec.describe Regard, type: :model do
  context 'associations' do
    it { should belong_to(:answer).required(false) }
    it { should have_db_column(:answer_id) }

    it_behaves_like 'has_question'
    it_behaves_like 'imagable'
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:image) }
  end
end
