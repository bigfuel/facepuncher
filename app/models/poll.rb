class Poll
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid
  include ProjectCacheable

  field :question, type: String
  field :state, type: String, default: 'inactive'
  field :start_date, type: DateTime
  field :end_date, type: DateTime

  attr_accessible :question, :start_date, :end_date

  belongs_to :project

  embeds_many :choices, cascade_callbacks: true
  accepts_nested_attributes_for :choices, reject_if: proc { |attributes| attributes[:content].blank? }, allow_destroy: true

  validates :question, presence: true

  scope :active, where(state: "active")
  scope :inactive, where(state: "inactive")

  state_machine initial: :inactive do
    event :activate do
      transition all => :active
    end

    event :deactivate do
      transition all => :inactive
    end
  end

  def self.cached_results
    where(state: "active").order_by([:created_at, :asc]).entries
  end

  def vote(choice_id)
    raise "choice_id required" unless choice_id
    choice = self.choices.find(choice_id)
    choice.votes += 1
    choice.save
  end
end