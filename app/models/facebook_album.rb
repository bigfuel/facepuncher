class FacebookAlbum
  include Mongoid::Document
  include Mongoid::Timestamps
  include ProjectCacheable

  field :name, type: String
  field :set_id, type: Integer

  attr_accessible :name, :set_id

  belongs_to :project

  validates :name, :set_id, presence: true

  def self.cached_results
    project_id = scoped.selector['project_id']
    FacebookGraph::Album.get(project_id)
  end
end