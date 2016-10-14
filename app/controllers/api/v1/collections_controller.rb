class Api::V1::CollectionsController < ApiController

  def index
    respond_to do |f|
      f.json do
        options = {}
        @elements = if params[:template]
          options = { :includes => params[:includes] } if params[:includes]
          current_property.elements.with_template(params[:template])
        else
          current_property.elements
        end
        @elements = if params[:order]
          @elements.by_field(params[:order])
        else
          @elements.by_title
        end
        render(:json => @elements.to_json(options))
      end
    end
  end

  def show
    respond_to do |f|
      f.json do
        @element = current_property.elements.find_by_id(params[:id])
        not_found if @element.nil?
        render(:json => @element.to_json(:includes => params[:includes]))
      end
    end
  end

end
