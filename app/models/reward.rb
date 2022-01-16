class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  validates :name, :image, presence: true
end
