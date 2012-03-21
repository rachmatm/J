require 'googleapis_maps'
class MapsController < ApplicationController

  def index
    response = Typhoeus::Request.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{URI.escape params[:keywords]}&sensor=true")

    respond_to do |format|
      format.json do
        begin
          results = Array.new

          ActiveSupport::JSON.decode(response.body)["results"].each do |obj|
            map_lat = obj["geometry"]["location"]["lat"]
            map_lng = obj["geometry"]["location"]["lng"]
            map_img = GoogleapisMaps.static_maps(100, 75, map_lat, map_lng)
            map_img_big = GoogleapisMaps.static_maps(198, 118, map_lat, map_lng)
            map_label = obj["formatted_address"]

            results << {:img => map_img, :label => map_label, :lat => map_lat, :lng => map_lng, :map_img_big => map_img_big}
          end

        rescue
          render :json => results
        end
        render :json => results
      end

      format.all { respond_not_found }
    end
  end
end