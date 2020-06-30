class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: :true

  def user_owner?(user)
    user_id == user.id
  end
end
