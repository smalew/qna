shared_examples_for 'API incorrect response' do
  it 'returns 422 status' do
    expect(response).to be_unprocessable
  end
end
