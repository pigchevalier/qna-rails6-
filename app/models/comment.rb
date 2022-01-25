class Comment < ApplicationRecord
  belongs_to :commenteable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
end
