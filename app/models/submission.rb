class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  include ProjectCacheable

  field :state, type: String, default: 'pending'
  field :facebook_name, type: String
  field :facebook_id, type: String
  field :facebook_email, type: String
  field :description, type: String

  attr_accessible :facebook_name, :facebook_id, :facebook_email, :description, :photo

  belongs_to :project

  mount_uploader :photo, ImageUploader

  paginates_per 10

  scope :pending, where(state: 'pending')
  scope :approved, where(state: 'approved')
  scope :denied, where(state: 'denied')

  validates :facebook_name, :facebook_id, :facebook_email, :photo, presence: true, if: -> { !Rails.env.development? }

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
end