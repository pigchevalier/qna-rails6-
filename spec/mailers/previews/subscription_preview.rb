# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview
  def digest
    SubscriptionMailer.digest(User.first, Question.first, Question.first.answers.first)
  end
end
