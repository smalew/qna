module Api
  module V1
    class ProfilesController < BaseController

      skip_authorization_check

      def me
        render json: current_resource_owner
      end

      def index
        render json: users
      end

      private

        def users
          @users ||= User.where.not(id: current_resource_owner.id)
        end
    end
  end
end
