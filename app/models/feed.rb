class Feed
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid

  field :name, type: String
  field :url, type: String
  field :limit, type: Integer, default: 10

  attr_accessible :name, :url, :limit

  belongs_to :project

  paginates_per 20

  validates :name, presence: true, uniqueness: { scope: :project_id, message: "has already been used in this project." }
  validates :url, presence: true
  validates :limit, numericality: { less_than_or_equal_to: 100 }
end