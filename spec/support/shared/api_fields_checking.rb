shared_examples_for 'API fields checking' do |fields|
  it 'returns all public fields' do
    fields.each do |attr|
      expect(record_response[attr]).to eq record.send(attr).as_json
    end
  end
end

shared_examples_for 'API updated fields checking' do |fields|
  it 'returns all public fields' do
    fields.each { |attr, value| expect(record_response[attr]).to eq value.as_json }
  end
end
