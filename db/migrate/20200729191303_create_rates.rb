class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.belongs_to :user
      t.belongs_to :ratable, polymorphic: true

      t.boolean :positive, null: false, default: false
      t.boolean :negative, null: false, default: false

      t.timestamps
    end
  end
end
