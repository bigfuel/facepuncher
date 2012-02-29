class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TaggableWithContext
  include ActsAsList::Mongoid

  field :title, type: String
  field :content, type: String
  field :url, type: String

  taggable

  attr_accessible :title, :content, :url

  belongs_to :project

  after_create :init_list

  mount_uploader :image, ImageUploader

  paginates_per 5

  validates :title, :content, :url, presence: true

  default_scope order_by(:position, :asc)
  scope :has_images, where(:image.ne => nil) # TODO: check to see if image is nil when you remove an image
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

  private
  # TODO: re-evaluate this method
  def init_list
    if self.position.nil?
      self.project.posts.init_list!
      self.reload
    end
  end
end