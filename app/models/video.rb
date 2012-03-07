class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid
  include ProjectCacheable

  field :youtube_id, type: String
  field :name, type: String
  field :description, type: String

  attr_accessible :youtube_id, :name, :description, :screencap

  belongs_to :project

  mount_uploader :screencap, ImageUploader

  validates :youtube_id, presence: true

  scope :pending, where(state: "pending")
  scope :approved, where(state: "approved")
  scope :denied, where(state: "denied")

  state_machine initial: :pending do
    event :approve do
      transition [:pending, :denied] => :approved
    end

    event :deny do
      transition [:pending, :approved] => :denied
    end
  end

  def self.cached_results
    where(state: "approved").order_by([:created_at, :asc]).entries
  end
end
