class GoogleapisMaps
  def self.static_maps(width, height, lat, lng, zoom = 9)
    params = "size=#{width}x#{height}" + "&"
    params += "zoom=#{zoom}" + "&"
    params += "markers=color:red%7Clabel:L%7Csize:mid%7C#{lat},#{lng}" + "&"
    params += "&sensor=true"

    "http://maps.googleapis.com/maps/api/staticmap?#{params}"
  end
end