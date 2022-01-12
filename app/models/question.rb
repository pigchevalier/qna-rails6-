class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_one :best_answer, foreign_key: :best_of_question_id, class_name: 'Answer', dependent: :nullify

  has_many_attached :files

  validates :title, :body, presence: true
end
