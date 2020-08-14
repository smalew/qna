class Comment < ApplicationRecord
  include HasUser
  belongs_to :commentable, polymorphic: true

  validates_presence_of :body
end
