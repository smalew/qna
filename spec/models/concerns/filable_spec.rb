require 'rails_helper'

shared_examples 'filable' do
  it { expect(build(described_class.name.underscore.to_sym).files).to be_instance_of(ActiveStorage::Attached::Many) }
end
