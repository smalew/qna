module Crudable
  extend ActiveSupport::Concern

  included do
    before_action :record, only: %i[show create update destroy]
    before_action :records, only: %i[index]

    authorize_resource
  end

  def index
    render json: records, each_serializer: records_serializer
  end

  def show
    render json: record, serializer: record_serializer
  end

  def create
    record.user = current_resource_owner

    if record.save
      render json: record, serializer: record_serializer
    else
      render status: :unprocessable_entity, json: record.errors
    end
  end

  def update
    if current_ability.can?(:update, record) && record.update(record_params)
      render json: record, serializer: record_serializer
    else
      render status: :unprocessable_entity, json: record.errors
    end
  end

  def destroy
    if current_ability.can?(:destroy, record) && record.destroy
      render json: true
    else
      render status: :unprocessable_entity, json: false
    end
  end
end
