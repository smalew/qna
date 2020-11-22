# frozen_string_literal: true

class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.belongs_to :user
      t.belongs_to :ratable, polymorphic: true

      t.integer :status, null: false, default: 1

      t.timestamps
    end
  end
end
