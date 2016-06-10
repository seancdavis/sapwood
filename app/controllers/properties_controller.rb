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
#  hidden_labels :text             default([]), is an Array
#  api_key       :string
#

class PropertiesController < ApplicationController

  before_filter :verify_property_access, :except => [:new, :create]

  def new
    not_found unless current_user.is_admin?
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

  def show
  end

  def edit
    not_found unless current_user.is_admin?
    render "properties/setup/#{params[:step]}" if params[:step]
  end

  def update
    if current_property.update(property_params)
      redirect_to redirect_path
    else
      render 'edit'
    end
  end

  def import
  end

  def process_import
    begin
      elements = ImportElements.call(
        :property_id => current_property.id,
        :csv => File.read(params[:property][:csv].path),
        :template_name => params[:property][:template_name]
      )
      redirect_to edit_property_path(current_property),
                  :notice => "#{elements.size} elements imported!"
    rescue => e
      @error = e.class
      render 'import'
    end
  end

  private

    def property_params
      hidden_labels = if params[:property] && params[:property][:hidden_labels]
        params[:property][:hidden_labels].split(',')
      else
        []
      end
      params.require(:property)
        .permit(:title, :color, :templates_raw, :forms_raw,
                :labels => Property.labels)
        .merge(:hidden_labels => hidden_labels)
    end

    def redirect_path
      params[:property][:redirect_to] || edit_property_path(current_property)
    end

end
