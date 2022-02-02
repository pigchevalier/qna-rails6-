class SubscriptionMailer < ApplicationMailer
  def digest(user, question, answer)
    @question = question
    @answer = answer
    mail to: user.email
  end
end
