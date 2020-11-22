# frozen_string_literal: true

shared_examples_for 'API Author checking' do
  it 'record contains links' do
    expect(record_response['user_id']).to eq(user.id)
  end
end
