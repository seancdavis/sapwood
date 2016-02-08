# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  labels        :json
#  templates_raw :text
#  forms_raw     :text
#

class PropertiesController < ApplicationController

  def new
    @current_property = Property.new
  end

  def create
    @current_property = Property.new(property_params)
    if current_property.save
      redirect_to property_setup_path(current_property, :color)
    else
      render 'new'
    end
  end

  def edit
    render "properties/setup/#{params[:step]}" if params[:step]
  end

  def update
    if current_property.update(property_params)
      redirect_to redirect_path
    else
      render 'edit'
    end
  end

  private

    def property_params
      params.require(:property)
        .permit(:title, :color, :templates_raw, :forms_raw,
                :labels => [:elements, :documents, :collections, :responses])
    end

    def redirect_path
      params[:property][:redirect_to] || edit_property_path(current_property)
    end

end
