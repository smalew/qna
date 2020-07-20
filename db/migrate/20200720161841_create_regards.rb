class CreateRegards < ActiveRecord::Migration[6.0]
  def change
    create_table :regards do |t|
      t.belongs_to :question
      t.belongs_to :answer
      t.string :title

      t.timestamps
    end
  end
end
