module OauthServices
  class TwitterService
    attr_reader :uid

    def call(uid:)
      @uid = uid.to_s

      authorization&.user
    end

    private

      def authorization
        @authorization ||= Authorization.where(provider: 'twitter', uid: uid).first
      end
  end
end
