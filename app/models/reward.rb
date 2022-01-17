class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true
  belongs_to :user, optional: true

  validates :name, :image, presence: true
end
