# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
class Question < ApplicationRecord
  include HasUser

  include Linkable
  include Filable
  include Answerable
  include Commentable

  has_one :regard, dependent: :destroy
  has_many :rates, as: :ratable, dependent: :destroy
  accepts_nested_attributes_for :regard, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates_associated :regard

  def best_answer
    answers.best.first
  end
end
