class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def vote(object)
    votes.find_by(voteable: object)
  end

  def vote?(object)
    votes.find_by(voteable: object).present?
  end
end
