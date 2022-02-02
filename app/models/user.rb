class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subs, dependent: :destroy

  def vote(object)
    votes.find_by(voteable: object)
  end

  def vote?(object)
    votes.find_by(voteable: object).present?
  end

  def sub(question)
    subs.find_by(question: question)
  end

  def sub?(question)
    subs.find_by(question: question).present?
  end
end
