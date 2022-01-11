class AddBestOfReferenceToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :best_of_question, foreign_key: {to_table: :questions}
  end
end
