module Rated
  extend ActiveSupport::Concern

  def rate_up
    record.rate_up_by!(current_user) if can?(:rate_up, record)

    success_responce
  end

  def rate_down
    record.rate_down_by!(current_user) if can?(:rate_down, record)

    success_responce
  end

  def cancel_rate
    record.cancel_rate_for!(current_user) if can?(:cancel_rate, record)

    success_responce
  end

  private

  def record
    send(controller_name.singularize.underscore)
  end

  def success_responce
    render json: { record_id: record.id, difference: record.difference_in_rates }
  end
end
