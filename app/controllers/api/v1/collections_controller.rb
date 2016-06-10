class Api::V1::CollectionsController < ApiController

  def show
    respond_to do |f|
      f.json do
        @collection = current_property.collections.find_by_id(params[:id])
        @collection.nil? ? not_found : render(:json => @collection)
      end
    end
  end

end
