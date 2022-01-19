class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :value, presence: true
  validates :user, uniqueness: { scope: [:voteable_id, :voteable_type] }
end
