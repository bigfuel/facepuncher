class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  include ProjectCacheable

  field :state, type: String, default: 'pending'
  field :facebook_name, type: String
  field :facebook_id, type: String
  field :facebook_email, type: String
  field :description, type: String

  attr_accessible :facebook_name, :facebook_id, :facebook_email, :description

  belongs_to :project

  mount_uploader :photo, ImageUploader

  paginates_per 10

  scope :pending, where(state: 'pending')
  scope :submitted, where(state: 'submitted')
  scope :approved, where(state: 'approved')
  scope :denied, where(state: 'denied')

  validates :facebook_name, :facebook_id, :facebook_email, :photo, presence: true, if: -> { !Rails.env.development? }

  state_machine initial: :pending do
    event :submit do
      transition pending: :submitted
    end

    event :approve do
      transition [:submitted, :denied] => :approved
    end

    event :deny do
      transition [:submitted, :approved] => :denied
    end
  end

  def self.cached_results
    order_by([:created_at, :asc]).entries
  end
end