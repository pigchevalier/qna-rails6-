class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(object)
    Subscription.distribution(object)
  end
end
