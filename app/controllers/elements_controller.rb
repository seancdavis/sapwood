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
    elsif params[:sort_by] && params[:sort_in]
      current_property.elements.with_template(current_template.name)
                      .by_field(params[:sort_by], params[:sort_in])
    elsif current_template.list['order']
      order = current_template.list['order']
      params[:sort_by] = order['by']
      params[:sort_in] = order['in'] || 'asc'
      current_property.elements.with_template(current_template.name)
                      .by_field(order['by'], order['in'].try(:upcase))
    else
      params[:sort_by] = current_template.primary_field.name
      params[:sort_in] = 'asc'
      current_property.elements.by_title.with_template(current_template.name)
    end
    respond_to do |format|
      format.html do
        if current_template && current_template.document?
          redirect_to [current_property, current_template, :documents]
        end
      end
      format.json
    end
  end

  def search
    not_found unless params[:q]
    @elements = current_property.elements.search_by_title(params[:q]).limit(10)
    respond_to do |format|
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
      send_notifications!
      redirect_to [current_property, current_template, :elements],
                  :notice => "#{current_template.title} saved successfully!"
    else
      render 'new'
    end
  end

  def edit
    not_found if current_element.blank?
  end

  def update
    if current_element.update(element_params)
      send_notifications!
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
      params
        .require(:element)
        .permit(:title, :template_name,
                :template_data => current_template.fields.collect(&:name))
    end

    def send_notifications!
      current_element.send_notifications!(action_name, current_user)
    end

end
