class Subscription
  def self.distribution(object)
    object.question.subs.each do |sub|
      SubscriptionMailer.digest(sub.user, object.question, object).deliver_later
    end
  end
end
