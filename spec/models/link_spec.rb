require 'rails_helper'

RSpec.describe Link, type: :model do
  context 'associations' do
    it { should belong_to(:linkable) }
  end

  context 'validations' do
    it { should allow_value('http://test.com').for(:url) }
    it { should_not allow_value('test.com').for(:url) }
  end

  context 'methods' do
    describe '#gist?' do
      let!(:gist_link) { create(:link, url: 'https://gist.github.com/user/ca9b0cab4a7847c') }
      let!(:link) { create(:link, url: 'https://site.com') }

      it { expect(gist_link.gist?).to be_truthy }
      it { expect(link.gist?).to be_falsey }
    end

    describe '#load_gist' do
      let!(:gist_link) { create(:link, url: 'https://gist.github.com/user/ca9b0cab4a7847c') }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:gist).and_return('Files')
      end

      it { expect(gist_link.load_gist).to eq('Files') }
    end
  end
end
