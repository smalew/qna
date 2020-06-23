require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'associations' do
    it { should belong_to(:question) }
    it { should have_db_column(:question_id) }
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
  end
end
