class Question < ApplicationRecord
  include Voteable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :best_answer, foreign_key: :best_of_question_id, class_name: 'Answer', dependent: :nullify
  has_many :links, dependent: :destroy, as: :linkable
  has_many :rewards, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commenteable
  has_many :subs, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :rewards, reject_if: :all_blank

  validates :title, :body, presence: true

  def set_best_answer(best_answer_id, current_user)
    Question.transaction do
      self.update!(best_answer: Answer.find(best_answer_id))
      if self.rewards.present?
        self.rewards.update_all!(answer: self.best_answer, user: current_user)
      end
    end
  end

  def self.last_day
    Question.where("created_at >= :last_day", { last_day: 1.days.ago } )
  end
end
