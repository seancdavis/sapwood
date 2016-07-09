class Api::V1::ElementsController < ApiController

  def index
    respond_to do |f|
      f.json do
        @elements = if params[:template]
          current_property.elements.with_template(params[:template])
        else
          current_property.elements
        end
        @elements = if params[:order]
          @elements.by_field(params[:order])
        else
          @elements.by_title
        end
        render(:json => @elements.to_json(:includes => params[:includes]))
      end
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

  def webhook
    Rails.logger.debug "****************************************"
    Rails.logger.debug "\n----- INCOMING WEBHOOK -----\n"
    Rails.logger.debug params.to_yaml
    Rails.logger.debug "****************************************"
    render :nothing => true
  end

end
