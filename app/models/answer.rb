class Answer < ApplicationRecord
  include Voteable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, required: false, dependent: :nullify
  has_many :comments, dependent: :destroy, as: :commenteable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
end
