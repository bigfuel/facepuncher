class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :address, type: String
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal

  attr_accessible :name, :address, :latitude, :longitude

  embedded_in :locationable, polymorphic: true

  validates :name, :address, :latitude, :longitude, presence: true
end