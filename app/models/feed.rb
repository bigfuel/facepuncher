class Feed
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid

  field :name, type: String
  field :url, type: String
  field :limit, type: Integer, default: 10
  field :rss, type: Hash, default: Hash.new

  attr_accessible :name, :url, :limit, :rss

  belongs_to :project

  paginates_per 5

  validates :name, presence: true, uniqueness: { scope: :project_id, message: "has already been used in this project." }
  validates :url, presence: true
  validates :limit, numericality: { less_than_or_equal_to: 100 }

  after_save :fetch_feed

  def to_param
    self.name
  end

  def self.find_by_name(name)
    where(name: name).limit(1).first
  end
  
  protected
  def fetch_feed
    RssFeeds.perform_async self.project.name, self.name
  end
end