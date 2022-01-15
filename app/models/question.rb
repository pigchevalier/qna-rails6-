class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_one :best_answer, foreign_key: :best_of_question_id, class_name: 'Answer', dependent: :nullify
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
end
