class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.belongs_to :voteable, polymorphic: true
      t.references :user, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
