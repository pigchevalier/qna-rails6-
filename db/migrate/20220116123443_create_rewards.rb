class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.string :image
      t.references :question, null: false, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
