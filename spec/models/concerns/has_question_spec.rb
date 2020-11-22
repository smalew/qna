# frozen_string_literal: true

require 'rails_helper'

shared_examples 'has_question' do
  it { should belong_to(:question) }

  it { should have_db_column(:question_id) }
end
