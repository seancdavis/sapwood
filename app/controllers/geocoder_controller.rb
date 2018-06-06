class GeocoderController < ApplicationController

  def search
    not_found unless params[:q]
    @geocode = Geokit::Geocoders::GoogleGeocoder.geocode(params[:q])
    respond_to do |format|
      format.json { render plain: @geocode.to_json }
    end
  end

end
