# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  body          :text
#  template_data :json             default({})
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  folder_id     :integer
#

class ElementsController < ApplicationController

  before_filter :verify_property_access

  def index
    if current_folder.present?
      @elements = current_folder.elements
      @folders = current_folder.children
    else
      @elements = current_property.elements.roots
      @folders = current_property.folders.roots
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    not_found if params[:template].blank?
    @current_element = current_property.elements.build
  end

  def create
    @current_element = current_property.elements.build(element_params)
    if current_element.save
      redirect_to redirect_path,
                  :notice => "#{current_template.title} saved successfully!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_element.update(element_params)
      redirect_to redirect_path,
                  :notice => "#{current_template.title} saved successfully!"
    else
      render 'edit'
    end
  end

  def destroy
    current_element.destroy
    redirect_to property_elements_path(current_property)
  end

  private

    def element_params
      p = params
        .require(:element)
        .permit(:title, :body, :template_name, :folder_id)
      new_data = params[:element][:template_data]
      if new_data.present?
        old_data = current_element? ? current_element.template_data : {}
        p = p.merge(:template_data => old_data.merge(new_data))
      end
      p
    end

    def redirect_path
      if current_element.folder.nil?
        property_elements_path(current_property)
      else
        property_folder_path(current_property, current_element.folder)
      end
    end

end
