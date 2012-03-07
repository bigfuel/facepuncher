class Signup
  include Mongoid::Document
  include Mongoid::Timestamps
  include ProjectCacheable

  field :state, type: String, default: 'pending'
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :address, type: String
  field :city, type: String
  field :state_province, type: String
  field :zip_code, type: String

  attr_accessible :email, :first_name, :last_name, :address, :city, :state_province, :zip_code, :email_confirmation

  belongs_to :project

  validates_length_of :email, :first_name, :last_name, :address, :city, :state_province, :zip_code, maximum: 255, message: "has exceeded the maximum character limit."
  validates_confirmation_of :email, if: Proc.new { |signup| signup.email_confirmation }

  validates :email, :first_name, :last_name, presence: true
  validates :email, format: { with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i }, uniqueness: { scope: :project_id, message: "has already been used to sign up." }

  scope :cached, order_by([:created_at, :asc])
  scope :pending, where(state: "pending")
  scope :uploaded, where(state: "uploaded")

  state_machine initial: :pending do
    event :upload do
      transition all => :uploaded
    end

    event :complete do
      transition :pending => :completed
    end
  end

  def self.cached_results
    order_by([:created_at, :asc]).entries
  end
end