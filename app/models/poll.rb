class Poll
  class InvalidChoiceError < StandardError; end
  class ChoiceRequiredError < StandardError; end

  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid

  field :state, type: String, default: 'inactive'
  field :question, type: String
  field :start_date, type: DateTime
  field :end_date, type: DateTime

  attr_accessible :question, :start_date, :end_date, :choices_attributes

  belongs_to :project

  paginates_per 20

  embeds_many :choices, cascade_callbacks: true
  accepts_nested_attributes_for :choices, reject_if: proc { |attributes| attributes[:content].blank? }, allow_destroy: true

  validates :question, presence: true
  validates_associated :choices

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

  def vote(choice_id)
    begin
      self.vote!(choice_id)
    rescue InvalidChoiceError, ChoiceRequiredError => e
      self.errors.add :choices, e.message
      false
    end
  end

  def vote!(choice_id)
    raise ChoiceRequiredError, "choice required" if choice_id.blank?
    begin
      choice = self.choices.find(choice_id)
    rescue Mongoid::Errors::DocumentNotFound
      raise InvalidChoiceError, "choice_id could not be found"
    end
    choice.votes += 1
    choice.save
  end
end