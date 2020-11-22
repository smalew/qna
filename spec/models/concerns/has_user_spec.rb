# frozen_string_literal: true

require 'rails_helper'

shared_examples 'has_user' do
  it { should belong_to(:user) }

  it { should have_db_column(:user_id) }
end
