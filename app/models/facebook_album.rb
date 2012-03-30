class FacebookAlbum
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :set_id, type: Integer
  field :limit, type: Integer, default: 10
  field :graph, type: Hash, default: Hash.new

  attr_accessible :name, :set_id, :limit, :graph

  belongs_to :project

  paginates_per 20

  validates :name, :set_id, presence: true
  validates :name, format: { with: /^[\S]+$/i }, uniqueness: { scope: :project_id, message: "has already been used in this project." }

  after_save :fetch_album

  protected
  def fetch_album
    FetchAlbum.perform_async self.project.name, self.name
  end
end