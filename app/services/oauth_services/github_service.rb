module OauthServices
  class GithubService
    attr_reader :uid, :email

    def call(uid:, email:)
      @uid = uid.to_s
      @email = email

      return authorization.user if authorization.present?

      user || create_user
      create_authorization

      user
    end

    private

      def authorization
        @authorization ||= Authorization.where(provider: 'github', uid: uid).first
      end

      def user
        @user ||= User.where(email: email).first
      end

      def create_user
        @user = User.create!(email: email, password: password, password_confirmation: password)
      end

      def password
        @password ||= Devise.friendly_token[0, 20]
      end

      def create_authorization
        user.authorizations.create(provider: 'github', uid: uid)
      end
  end
end
