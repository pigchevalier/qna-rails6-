module Serialized
  extend ActiveSupport::Concern
  
  def render_json(items)
    render json: items
  end

  def render_errors(item)
    render json: item.errors.full_messages, status: :unprocessable_entity
  end
end
