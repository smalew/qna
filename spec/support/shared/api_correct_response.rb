# frozen_string_literal: true

shared_examples_for 'API correct response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end
