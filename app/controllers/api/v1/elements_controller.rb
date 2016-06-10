class Api::V1::ElementsController < ApiController

  def index
    respond_to do |f|
      f.json { render(:json => current_property.elements) }
    end
  end

  def show
    respond_to do |f|
      f.json do
        @element = current_property.elements.find_by_id(params[:id])
        @element.nil? ? not_found : render(:json => @element)
      end
    end
  end

end
