# frozen_string_literal: true

class AddBestAnswerIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :best_answer_id, :bigint
    add_index :questions, :best_answer_id
  end
end
