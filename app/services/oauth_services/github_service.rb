module OauthServices
  class GithubService < ApplicationService
    def call
      return authorization.user if authorization.present?

      user || create_user
      create_authorization

      user
    end

    private

      def authorization
        @authorization ||= Authorization.where(provider: params.provider, uid: params.uid.to_s).first
      end

      def user
        @user ||= User.where(email: email).first
      end

      def create_user
        @user = User.create!(email: email, password: password, password_confirmation: password)
      end

      def email
        @email ||= params.info[:email]
      end

      def password
        @password ||= Devise.friendly_token[0, 20]
      end

      def create_authorization
        user.authorizations.create(provider: params.provider, uid: params.uid)
      end
  end
end
