# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  template_data :json             default({})
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  url           :string
#  archived      :boolean          default(FALSE)
#  processed     :boolean          default(FALSE)
#

class ElementsController < ApplicationController

  before_filter :verify_property_access

  def index
    not_found if current_template.nil? && params[:template_id] != '__all'
    @elements = if params[:template_id] == '__all'
      current_property.elements.by_title
    else
      current_property.elements.by_title.with_template(current_template.name)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    not_found if current_template.blank?
    @current_element = current_property.elements
      .build(:template_name => current_template.name)
  end

  def create
    @current_element = current_property.elements.build(element_params)
    if current_element.save!
      redirect_to [current_property, current_template, :elements],
                  :notice => "#{current_template.title} saved successfully!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_element.update(element_params)
      redirect_to [current_property, current_template, :elements],
                  :notice => "#{current_template.title} saved successfully!"
    else
      render 'edit'
    end
  end

  def destroy
    current_element.destroy
    redirect_to [current_property, current_template, :elements]
  end

  private

    def element_params
      # raise '123'
      params
        .require(:element)
        .permit(:title, :template_name,
                :template_data => current_template.fields.collect(&:name))
      # new_data = params[:element][:template_data]
      # if new_data.present?
      #   old_data = current_element? ? current_element.template_data : {}
      #   p = p.merge(:template_data => old_data.merge(new_data))
      # end
      # p
    end

end
