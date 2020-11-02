module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :rates, as: :ratable, dependent: :destroy
  end

  def rate_up_by!(user)
    return if user.cannot?(:rate_up, self)

    rate = rates.find_or_initialize_by(user: user)

    rate.update!(status: :positive)
  end

  def rate_down_by!(user)
    return if user.cannot?(:rate_down, self)

    rate = rates.find_or_initialize_by(user: user)

    rate.update!(status: :negative)
  end

  def cancel_rate_for!(user)
    return if user.cannot?(:cancel_rate, self)

    rates.find_by(user: user)&.destroy
  end

  def difference_in_rates
    rates.sum(:status)
  end
end
