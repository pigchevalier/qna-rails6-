class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  has_many :files, serializer: FileSerializer
  has_many :comments
  has_many :links
  belongs_to :user
  belongs_to :question

  def files
    object.files
  end
end
