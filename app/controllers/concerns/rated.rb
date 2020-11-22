# frozen_string_literal: true

module Rated
  extend ActiveSupport::Concern

  def rate_up
    rate.update!(status: :positive) if can?(:rate_up, record)

    success_responce
  end

  def rate_down
    rate.update!(status: :negative) if can?(:rate_down, record)

    success_responce
  end

  def cancel_rate
    record.rates.find_by(user: current_user)&.destroy if can?(:cancel_rate, record)

    success_responce
  end

  private

  def record
    send(controller_name.singularize.underscore)
  end

  def rate
    @rate ||= record.rates.find_or_initialize_by(user: current_user)
  end

  def success_responce
    render json: { record_id: record.id, difference: record.rates.sum(:status) }
  end
end
