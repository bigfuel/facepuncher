class FacebookEvent
  include Mongoid::Document
  include Mongoid::Timestamps
  include ProjectCacheable

  field :name, type: String
  field :limit, type: Integer, default: 10

  attr_accessible :name, :limit

  belongs_to :project

  validates :name, :limit, presence: true

  def self.cached_results
    project_id = scoped.selector['project_id']
    FacebookGraph::Event.get(project_id)
  end
end