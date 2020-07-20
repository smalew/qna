class Question < ApplicationRecord
  belongs_to :user

  has_one :regard, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :regard, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates_associated :regard

  def best_answer
    answers.best.first
  end
end
