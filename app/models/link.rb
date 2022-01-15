class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist
    if self.url.include? 'https://gist.github.com/'
      self.url.partition("#").first + ".js"
    end
  end
end
