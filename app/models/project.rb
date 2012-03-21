require 'mongoid/carrierwave_fix'

class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CarrierwaveFix

  field :state, type: String, default: 'inactive'
  field :name, type: String
  field :description, type: String
  field :facebook_app_id, type: String
  field :facebook_app_secret, type: String
  field :google_analytics_tracking_code, type: String
  field :production_url, type: String
  field :repo, type: String

  index :name, unique: true

  attr_accessible :name, :description, :facebook_app_id, :facebook_app_secret, :google_analytics_tracking_code, :production_url, :repo

  after_create :generate_master_release

  has_many :events, dependent: :destroy
  has_many :signups, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :feeds, dependent: :destroy
  has_many :facebook_albums, dependent: :destroy
  has_many :facebook_events, dependent: :destroy
  has_many :releases, dependent: :destroy
  has_many :view_templates, dependent: :destroy

  scope :active, where(state: 'active')
  scope :inactive, where(state: 'inactive')

  paginates_per 50

  validates :name, presence: true, uniqueness: true
  validates :repo, presence: true

  state_machine initial: :inactive do
    event :activate do
      transition inactive: :active
    end

    event :deactivate do
      transition active: :inactive
    end
  end

  def touch
    self.updated_at = Time.current
    self.save
  end

  def to_param
    self.name
  end

  def live_release
    self.releases.where(state: "live").limit(1).first
  end

  def next_release
    past = self.releases.past
    past.empty? ? nil : past.first
  end

  def self.find_by_name(name)
    where(name: name).limit(1).first
  end

  protected
  def generate_master_release
    self.releases.create!
    DeployProject.perform_async self.name
  end
end