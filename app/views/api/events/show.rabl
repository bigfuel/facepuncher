object @event
attributes :id, :name, :state, :type, :start_date, :end_date, :url, :details, :created_at, :updated_at
child(:location) { attributes :name, :address, :latitude, :longitude }
