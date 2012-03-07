class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid
  include ProjectCacheable

  field :name, type: String
  field :description, type: String

  attr_accessible :name, :description, :image

  belongs_to :project

  mount_uploader :image, ImageGridUploader

  scope :pending, where(state: "pending")
  scope :approved, where(state: "approved")
  scope :denied, where(state: "denied")

  validates :image, presence: true

  state_machine initial: :pending do
    event :approve do
      transition [:pending, :denied] => :approved
    end

    event :deny do
      transition [:pending, :approved] => :denied
    end
  end

  def self.cached_results
    order_by([:created_at, :asc]).entries
  end

  def as_json(options={})
    super({ methods: :image }.merge(options))
  end
end