require 'rails_helper'

shared_examples 'questionable' do
  it { should have_many(:questions).dependent(:destroy) }
end
