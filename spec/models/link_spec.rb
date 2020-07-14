require 'rails_helper'

RSpec.describe Link, type: :model do
  context 'associations' do
    it { should belong_to(:linkable) }
  end

  context 'validations' do
    it { should allow_value('http://test.com').for(:url) }
    it { should_not allow_value('test.com').for(:url) }
  end
end
