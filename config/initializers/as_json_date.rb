class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime('%a %b %d, %Y %I:%M:%S %p')
  end
end