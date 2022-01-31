class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :files, serializer: FileSerializer
  has_many :answers, each_serializer: AnswerSerializer
  has_many :comments
  has_many :links
  belongs_to :user

  def files
    object.files
  end
end
