module Api
  module V1
    class ProfilesController < BaseController

      skip_authorization_check

      def me
        render json: current_resource_owner, serializer: ::V1::UserSerializer
      end

      def index
        render json: users, each_serializer: ::V1::UserSerializer
      end

      private

        def users
          @users ||= User.where.not(id: current_resource_owner.id)
        end
    end
  end
end
