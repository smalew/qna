module Rated
  extend ActiveSupport::Concern

  def rate_up
    record.rate_up_by!(current_user)

    render json: {
      status: 200,
      record_id: record.id,
      positives: record.rates.positives.count,
      negatives: record.rates.negatives.count,
      difference: record.difference_in_rates
    }
  end

  def rate_down
    record.rate_down_by!(current_user)

    render json: {
      status: 200,
      record_id: record.id,
      positives: record.rates.positives.count,
      negatives: record.rates.negatives.count,
      difference: record.difference_in_rates
    }
  end

  def cancel_rate
    record.cancel_rate_for!(current_user)

    render json: {
      status: 200,
      record_id: record.id,
      positives: record.rates.positives.count,
      negatives: record.rates.negatives.count,
      difference: record.difference_in_rates
    }
  end

  private

  def record
    send(controller_name.singularize.underscore)
  end
end
