class FacebookEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :limit, type: Integer, default: 10
  field :graph, type: Hash, default: Hash.new

  attr_accessible :name, :limit, :graph

  belongs_to :project

  paginates_per 20

  validates :name, :limit, presence: true
  validates :name, format: { with: /^[\S]+$/i }, uniqueness: { scope: :project_id, message: "has already been used in this project." }

  after_save :fetch_event

  def to_param
    self.name
  end

  def self.find_by_name(name)
    where(name: name).limit(1).first
  end
  
  protected
  def fetch_event
    FetchEvent.perform_async self.project.name, self.name
  end
end