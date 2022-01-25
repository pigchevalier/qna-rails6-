class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.belongs_to :commenteable, polymorphic: true
      t.references :user, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
