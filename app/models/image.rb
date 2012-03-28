class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid

  field :state, type: String, default: 'pending'
  field :name, type: String
  field :description, type: String

  attr_accessible :name, :description, :image

  belongs_to :project

  paginates_per 20

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
end