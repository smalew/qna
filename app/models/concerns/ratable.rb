module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :rates, as: :ratable, dependent: :destroy
  end

  def rate_up_by!(user)
    rate = rates.find_or_initialize_by(user: user)

    rate.update!(status: :positive)
  end

  def rate_down_by!(user)
    rate = rates.find_or_initialize_by(user: user)

    rate.update!(status: :negative)
  end

  def cancel_rate_for!(user)
    rates.find_by(user: user)&.destroy
  end

  def difference_in_rates
    rates.sum(:status)
  end
end
