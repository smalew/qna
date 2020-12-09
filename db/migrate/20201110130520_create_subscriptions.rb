# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.bigint :question_id
      t.bigint :user_id
    end

    add_index :subscriptions, :question_id
    add_index :subscriptions, :user_id
  end
end
