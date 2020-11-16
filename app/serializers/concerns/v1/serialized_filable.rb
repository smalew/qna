module V1
  module SerializedFilable
    extend ActiveSupport::Concern

    included do
      include Rails.application.routes.url_helpers

      attribute :files
    end

    def files
      object.files.map do |file|
        { id: file.id, url: rails_blob_url(file, only_path: true) }
      end
    end
  end
end
