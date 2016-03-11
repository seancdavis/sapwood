# == Schema Information
#
# Table name: collections
#
#  id          :integer          not null, primary key
#  title       :string
#  property_id :integer
#  item_data   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CollectionsController < ApplicationController

  before_filter :verify_property_access

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

  def edit
  end

  def update
    if current_collection.update(collection_params)
      redirect_to property_collections_path,
                  :notice => "#{current_collection.title} saved successfully!"
    else
      render 'edit'
    end
  end

  private

    def collection_params
      params.require(:collection).permit(:title, :item_data)
    end

end
