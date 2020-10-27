module OauthServices
  class TwitterService < ApplicationService
    def call
      authorization&.user
    end

    private

      def authorization
        @authorization ||= Authorization.where(provider: params.provider, uid: params.uid.to_s).first
      end
  end
end
