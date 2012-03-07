object @event
attributes :id, :name, :state, :type, :start_date, :end_date, :url, :details
child(:location) { attributes :name, :address, :latitude, :longitude }
