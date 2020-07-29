require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  context 'methods' do
    describe '#regards' do
      let(:user) { create(:user) }

      context 'without regards' do
        it { expect(user.regards).to eq([]) }
      end

      context 'with regards' do
        let(:answer) { create(:answer, user: user) }
        let!(:regard) { create(:regard, answer: answer) }

        it { expect(user.regards).to eq([regard]) }
      end

      context 'with answers without regards' do
        let(:answer) { create(:answer, user: user) }

        it { expect(user.regards).to eq([]) }
      end
    end
    describe '#author_of?' do
      let(:user) { create(:user) }

      let(:correct_struct) { Struct.new(:user_id) }
      let(:incorrect_struct) { Struct.new(:another_field_id) }

      context 'when user is owner for object' do
        let(:object) { correct_struct.new(user.id) }

        it { expect(user).to be_author_of(object) }
      end

      context 'when user is not owner for object' do
        let(:object) { correct_struct.new(create(:user).id) }

        it { expect(user).to_not be_author_of(object) }
      end

      context 'when user is not owner for object' do
        let(:object) { incorrect_struct.new(user.id) }

        it { expect(user).to_not be_author_of(object) }
      end
    end
  end
end
