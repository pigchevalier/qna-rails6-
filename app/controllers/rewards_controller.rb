class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rewards = Reward.where('answer_id = ANY(ARRAY[:u_id]::int[])', u_id: current_user.answers.ids)
  end
end
