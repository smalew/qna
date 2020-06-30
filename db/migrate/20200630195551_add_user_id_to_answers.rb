# frozen_string_literal: true

class AddUserIdToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :user
  end
end
