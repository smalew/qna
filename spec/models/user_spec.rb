# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  admin                  :boolean
#
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it_behaves_like 'questionable'
    it_behaves_like 'answerable'

    it { should have_many(:rates).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:access_grants).dependent(:delete_all) }
    it { should have_many(:access_tokens).dependent(:delete_all) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribes) }
  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  context 'methods' do
    describe 'from_omniauth' do
      let!(:user) { create(:user) }

      context 'for providers' do
        context 'github' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'test@mail.com' }) }
          let(:service) { double('FindForOauthService') }

          it 'calls FindForOauthService' do
            expect(OauthServices::GithubService).to receive(:new).and_return(service)
            expect(service).to receive(:call).with(uid: auth.uid, email: 'test@mail.com')
            User.find_for_oauth(auth)
          end
        end

        context 'twitter' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }
          let(:service) { double('FindForOauthService') }

          it 'calls FindForOauthService' do
            expect(OauthServices::TwitterService).to receive(:new).and_return(service)
            expect(service).to receive(:call).with(uid: auth.uid)
            User.find_for_oauth(auth)
          end
        end
      end
    end

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

    describe '#rated?' do
      let(:user) { create(:user) }

      let(:question) { create(:question) }
      let!(:rate) { create(:rate, ratable: question, user: author) }

      context 'when question has been rated by user' do
        let(:author) { user }

        it { expect(user).to be_rated(question) }
      end

      context 'when question has not been rated by user' do
        let(:author) { create(:user) }

        it { expect(user).to_not be_rated(question) }
      end
    end

    describe '#confirmation_required?' do
      let!(:user) { create(:user) }

      subject { user.confirmation_required? }

      context 'when user auth through twitter' do
        let!(:auth) { create(:authorization, provider: 'twitter', user: user) }

        it { is_expected.to be_truthy }
      end

      context 'when user auth through another provider' do
        let!(:auth) { create(:authorization, provider: 'some_provider', user: user) }

        it { is_expected.to be_falsey }
      end

      context 'when user without any auth' do
        it { is_expected.to be_falsey }
      end
    end
  end
end
