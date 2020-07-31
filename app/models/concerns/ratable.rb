module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :rates, as: :ratable, dependent: :destroy
  end

  def rate_up_by!(user)
    return if user.author_of?(self)

    rate = rates.find_or_initialize_by(user: user)

    rate.update!(positive: true, negative: false)
  end

  def rate_down_by!(user)
    return if user.author_of?(self)

    rate = rates.find_or_initialize_by(user: user)

    rate.update!(positive: false, negative: true)
  end

  def cancel_rate_for!(user)
    rates.find_by(user: user)&.destroy
  end

  def difference_in_rates
    rates.positives.count - rates.negatives.count
  end
end
