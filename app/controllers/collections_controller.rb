class CollectionsController < ApplicationController

  def index
  end

  def new
    @current_collection = Collection.new
  end

  def create
    @current_collection = current_property.collections.build(collection_params)
    if current_collection.save
      redirect_to property_collections_path,
                  :notice => "#{current_collection.title} saved successfully!"
    else
      render 'new'
    end
  end

  private

    def collection_params
      params.require(:collection).permit(:title, :item_data)
    end

end
