# frozen_string_literal: true

shared_examples_for 'API Files checking' do
  let(:files_in_response) { record_response['files'] }
  let(:files_for_checking) do
    record.files.map do |file|
      { id: file.id, url: rails_blob_url(file, only_path: true) }.stringify_keys
    end
  end

  it 'record contains file urls' do
    expect(files_in_response).to match_array(files_for_checking)
  end
end
