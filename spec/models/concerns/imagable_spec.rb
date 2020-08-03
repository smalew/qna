require 'rails_helper'

shared_examples 'imagable' do
  it { expect(build(described_class.name.underscore.to_sym).image).to be_instance_of(ActiveStorage::Attached::One) }
end
