module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def rating
    self.votes.sum(:value)
  end

  def current_user_vote(current_user)
    self.votes.find_by(user_id: current_user.id).id
  end

  def current_user_vote?(current_user)
    if self.votes.find_by(user_id: current_user.id).present?
      true
    else
      false
    end   
  end 
end
