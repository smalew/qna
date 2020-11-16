shared_examples_for 'API Links checking' do
  let(:links_in_response) { record_response['links'] }
  let(:links_for_checking) { links.map { |record| V1::LinksSerializer.new(record).as_json.deep_stringify_keys } }

  it 'record contains links' do
    expect(links_in_response).to match_array(links_for_checking)
  end
end
