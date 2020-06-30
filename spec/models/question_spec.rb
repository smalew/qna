require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
