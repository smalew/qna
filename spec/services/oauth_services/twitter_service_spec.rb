require 'rails_helper'

RSpec.describe OauthServices::TwitterService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

  subject { OauthServices::TwitterService.call(auth) }

  context 'user already has authorization' do
    it 'returns the user' do
      user.authorizations.create(provider: 'twitter', uid: '123456')

      is_expected.to eq(user)
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      it 'does not create new user' do
        expect { subject }.to_not change(User, :count)
      end

      it 'does not create new authorization' do
        expect { subject }.to_not change(Authorization, :count)
      end

      it 'returns empty answer' do
        is_expected.to eq(nil)
      end
    end
  end

  context 'user does not exist' do
    it 'does not create new user' do
      expect { subject }.to_not change(User, :count)
    end

    it 'does not create new authorization' do
      expect { subject }.to_not change(Authorization, :count)
    end

    it 'returns empty answer' do
      is_expected.to eq(nil)
    end
  end
end
