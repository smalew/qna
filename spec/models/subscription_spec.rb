# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  question_id :bigint
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#  best_answer :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end
end
