require 'rails_helper'

RSpec.describe Regard, type: :model do
  context 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:answer).required(false) }

    it { should have_db_column(:question_id) }
    it { should have_db_column(:answer_id) }

    it { expect(build(:regard).image).to be_instance_of(ActiveStorage::Attached::One) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:image) }
  end
end
