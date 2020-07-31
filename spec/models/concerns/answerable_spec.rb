require 'rails_helper'

shared_examples 'answerable' do
  it { should have_many(:answers).dependent(:destroy) }
end
