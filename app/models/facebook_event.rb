class FacebookEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :limit, type: Integer, default: 10

  attr_accessible :name, :limit

  belongs_to :project

  paginates_per 20

  validates :name, :limit, presence: true
  validates :name, uniqueness: { scope: :project_id, message: "has already been used in this project." }

  def self.cached_results
    project_id = scoped.selector['project_id']
    FacebookGraph::Event.get(project_id)
  end
end