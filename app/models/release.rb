class Release
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String
  field :branch, type: String, default: "master"
  field :live_date, type: Time, default: Time.current
  field :state, type: String, default: "staged"
  field :status, type: String

  attr_accessible :description, :branch, :live_date, :status

  belongs_to :project

  validates :live_date, presence: true
  validates :branch, presence: true
  validates_datetime :live_date, on: :create, on_or_after: Time.current - 1.minute

  default_scope order_by(:live_date, :desc)
  scope :future, -> { where(:live_date.gt => Time.current).order_by(:live_date, :asc) }
  scope :past, -> { where(:live_date.lte => Time.current).order_by(:live_date, :desc) }
  scope :staged, where(state: "staged")

  after_save :enqueue

  state_machine initial: :staged do
    before_transition any => :live do |release, transition|
      release.project.live_release.try(:stage)
      release.live_date = Time.current
    end

    event :stage do
      transition [:live] => :staged
    end

    event :go_live do
      transition [:staged] => :live
    end

    # event :deploy do
    #   transition [:staged] => :deploying
    # end
    #
    # event :go_live do
    #   transition [:deploying] => :live
    # end
  end

  def deployable?
    self != self.project.next_release
  end

  def enqueue
    if self.deployable?
      # TODO: fix this shit
      if self.live_date > Time.current
        Resque.enqueue_at(self.live_date, DeployProject, self.project.name)
      elsif self.live_date > 10.seconds.ago
        Resque.enqueue(DeployProject, self.project.name)
      end
    end
  end
end