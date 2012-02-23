window.fp = window.fp or {}
fp.maps = fp.maps or {}

find = (address, callback, errback = (error) -> alert(error)) ->
  geocoder = new google.maps.Geocoder()
  geocoder.geocode 'address': address, (results, status) ->
    switch status
      when google.maps.GeocoderStatus.OK
        callback results[0].geometry.location
      when google.maps.GeocoderStatus.ZERO_RESULTS
        errback "No results found for: " + address
      else
        errback "Look up was not successful for the following reason: " + status

fp.maps.find = find