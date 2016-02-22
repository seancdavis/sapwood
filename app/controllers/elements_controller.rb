class ElementsController < ApplicationController

  def index
  end

  def new
    @current_element = current_property.elements.build
  end

  def create
    @current_element = current_property.elements.build(element_params)
    if current_element.save
      redirect_to property_elements_path(current_property),
                  :notice => "#{current_template.title} saved successfully!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_element.update(element_params)
      redirect_to property_elements_path(current_property),
                  :notice => "#{current_template.title} saved successfully!"
    else
      render 'edit'
    end
  end

  private

    def element_params
      p = params
        .require(:element)
        .permit(:title, :body, :template_name)
      new_data = params[:element][:template_data]
      if new_data.present?
        old_data = current_element? ? current_element.template_data : {}
        p = p.merge(:template_data => old_data.merge(new_data))
      end
      p
    end

end
