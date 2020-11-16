module V1
  module SerializedTimestampable
    extend ActiveSupport::Concern

    included do
      attribute :created_at
      attribute :updated_at
    end

    def created_at
      object.created_at.as_json
    end

    def updated_at
      object.created_at.as_json
    end
  end
end
