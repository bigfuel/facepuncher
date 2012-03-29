class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid

  field :youtube_id, type: String
  field :state, type: String, default: 'pending'
  field :name, type: String
  field :description, type: String

  attr_accessible :youtube_id, :name, :description, :screencap

  belongs_to :project

  paginates_per 20

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
end
