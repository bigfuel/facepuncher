class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid
  include ProjectCacheable

  field :name, type: String
  field :state, type: String, default: 'pending'
  field :type, type: String
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :url, type: String
  field :details, type: String

  attr_accessible :name, :type, :start_date, :end_date, :url, :details

  embeds_one :location, as: :locationable

  belongs_to :project

  accepts_nested_attributes_for :location

  paginates_per 20

  validates :name, :start_date, presence: true

  default_scope order_by(:start_date, :asc)
  scope :pending, where(state: "pending")
  scope :approved, where(state: "approved")
  scope :denied, where(state: "denied")
  scope :future, where(:start_date.gt => Time.current)

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

  def as_json(options={})
    results = super({}.merge(options))
    results['start_date'] = start_date.strftime("%a %b %d, %Y %I:%M %p")
    results['end_date'] = end_date.strftime("%a %b %d, %Y %I:%M %p")
    results
  end
end