class Choice
  include Mongoid::Document
  include ActsAsList::Mongoid

  field :content, type: String
  field :votes, type: Integer, default: 0

  attr_accessible :content

  embedded_in :poll

  validates :content, presence: true

  mount_uploader :image, ImageUploader
end