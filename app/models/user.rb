class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include Answerable
  include Questionable

  has_many :rates, dependent: :destroy

  def author_of?(object)
    id == object.try(:user_id)
  end

  def regards
    answers.map(&:regard)
  end

  def rated?(record)
    rates.where(ratable: record).present?
  end
end
