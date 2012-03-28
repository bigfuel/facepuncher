class FacebookAlbum
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :set_id, type: Integer

  attr_accessible :name, :set_id

  belongs_to :project

  paginates_per 20

  validates :name, :set_id, presence: true
  validates :name, uniqueness: { scope: :project_id, message: "has already been used in this project." }

  def self.cached_results
    project_id = scoped.selector['project_id']
    FacebookGraph::Album.get(project_id)
  end
end