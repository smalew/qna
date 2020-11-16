shared_examples_for 'API Comments checking' do
  let(:comments_in_response) { record_response['comments'] }
  let(:comments_for_checking) { comments.map { |record| V1::CommentsSerializer.new(record).as_json.deep_stringify_keys } }

  it 'record contains comments' do
    expect(comments_in_response).to match_array(comments_for_checking)
  end
end
