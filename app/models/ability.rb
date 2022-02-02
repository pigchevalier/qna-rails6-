# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, [Question, Answer]
  end

  def user_abilities
    guest_abilities
    can :read, [Reward]
    can :create, [Answer, Question, Comment, Sub]
    can :create, Vote do |vote, voteable|
      voteable.user_id != user.id
    end
    can :destroy, [Answer, Question, Vote, Sub], user_id: user.id
    cannot :destroy, Vote, voteable: {user_id: user.id}
    can :destroy, Link, linkable: {user_id: user.id}
    can :update, [Answer, Question], user_id: user.id
    can :set_best_answer, Question, user_id: user.id
  end
end
