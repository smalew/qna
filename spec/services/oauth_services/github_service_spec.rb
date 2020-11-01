require 'rails_helper'

RSpec.describe OauthServices::GithubService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

  subject { OauthServices::GithubService.new.call(uid: auth.uid, email: email) }

  context 'user already has authorization' do
    let(:email) { user.email }

    it 'returns the user' do
      user.authorizations.create(provider: 'github', uid: '123456')

      is_expected.to eq(user)
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }
      let(:email) { user.email }

      it 'does not create new user' do
        expect { subject }.to_not change(User, :count)
      end

      it 'returns user' do
        is_expected.to eq(user)
      end

      it 'creates authorization for user' do
        expect { subject }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.authorizations.first

        expect(authorization.provider).to eq(auth.provider)
        expect(authorization.uid).to eq(auth.uid)
      end
    end
  end

  context 'user does not exist' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }
    let(:email) { 'new@user.com' }

    it 'creates new user' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'return new user' do
      is_expected.to be_a(User)
    end

    it 'fills user email' do
      expect(subject.email).to eq(auth.info[:email])
    end

    it 'creates authorization for user' do
      expect(subject.authorizations).to_not be_empty
    end

    it 'creates authorization with provider and uid' do
      authorization = subject.authorizations.first

      expect(authorization.provider).to eq(auth.provider)
      expect(authorization.uid).to eq(auth.uid)
    end
  end
end
