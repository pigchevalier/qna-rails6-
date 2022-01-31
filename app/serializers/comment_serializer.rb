class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commenteable_id, :user_id, :created_at, :updated_at
end
