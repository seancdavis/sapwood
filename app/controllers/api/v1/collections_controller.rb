class Api::V1::CollectionsController < ApiController

  def index
    respond_to do |f|
      f.json do
        @collections = if params[:type] && current_collection_type
          current_property.collections.by_title
                          .with_type(current_collection_type.name)
        elsif params[:type]
          []
        else
          current_property.collections.by_title
        end
        render(:json => @collections)
      end
    end
  end

  def show
    respond_to do |f|
      f.json do
        @collection = current_property.collections.find_by_id(params[:id])
        @collection.nil? ? not_found : render(:json => @collection)
      end
    end
  end

end
