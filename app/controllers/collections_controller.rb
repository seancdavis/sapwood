# == Schema Information
#
# Table name: collections
#
#  id                   :integer          not null, primary key
#  title                :string
#  property_id          :integer
#  item_data            :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  collection_type_name :string
#  field_data           :json             default({})
#

class CollectionsController < ApplicationController

  before_filter :verify_property_access

  def index
  end

  def new
    not_found if params[:collection_type].blank?
    @current_collection = current_property.collections.build
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
      p = params
        .require(:collection)
        .permit(:title, :item_data, :collection_type_name)
      new_data = params[:collection][:field_data]
      if new_data.present?
        old_data = if current_collection? && current_collection.field_data
          current_collection.field_data
        else
          {}
        end
        p = p.merge(:field_data => old_data.merge(new_data))
      end
      p
    end

end
