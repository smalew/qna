# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  commentable_type :string
#  commentable_id   :bigint
#  body             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Comment < ApplicationRecord
  include HasUser
  belongs_to :commentable, polymorphic: true

  validates_presence_of :body
end
