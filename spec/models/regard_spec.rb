# == Schema Information
#
# Table name: regards
#
#  id          :bigint           not null, primary key
#  question_id :bigint
#  answer_id   :bigint
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
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
