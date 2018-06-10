# frozen_string_literal: true

# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  templates_raw :text
#  api_key       :string
#

class PropertiesController < ApplicationController
  before_action :verify_property_access, except: [:new, :create]

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
    @last_updated = current_property.elements.last_updated.limit(20)
      .select { |el| el.template.present? }.first(5)
    @last_created = current_property.elements.last_created.limit(20)
      .select { |el| el.template.present? }.first(5)
  end

  def edit
    not_found unless is_property_admin?
    if params[:step]
      render "properties/setup/#{params[:step]}"
    elsif params[:screen]
      not_found unless %w{general config keys}.include?(params[:screen])
      render params[:screen]
    end
  end

  def update
    if current_property.update(property_params)
      redirect_to redirect_path
    else
      render 'edit'
    end
  end

  def import
    not_found unless is_property_admin?
  end

  def process_import
    not_found unless is_property_admin?
    begin
      elements = ImportElements.call(
        property_id: current_property.id,
        csv: File.read(params[:property][:csv].path),
        template_name: params[:property][:template_name]
      )
      redirect_to property_import_path(current_property),
                  notice: "#{elements.size} elements imported!"
    rescue => e
      @error = e.class
      render 'import'
    end
  end

  private

    def property_params
      params.require(:property).permit(:title, :color, :templates_raw)
    end

    def redirect_path
      params[:property][:redirect_to] ||
      request.referrer ||
      edit_property_path(current_property, 'general')
    end
end
