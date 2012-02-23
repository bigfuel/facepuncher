class ViewTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  include DatabaseViews::Orm::Mongoid

  belongs_to :project
end