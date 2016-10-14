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
        not_found if @element.nil?
        render(:json => @element.to_json(:includes => params[:includes]))
      end
    end
  end

  def create
    @template = current_property.find_template(params[:template])
    forbidden if @template.nil?
    @element = Element.new(:template_data => element_params.to_hash)
    @element.property = current_property
    @element.template_name = @template.name
    render(:json => (@element.save ? @element : @element.errors.messages))
  end

  def webhook
    Rails.logger.debug "****************************************"
    Rails.logger.debug "\n----- INCOMING WEBHOOK -----\n"
    Rails.logger.debug params.to_yaml
    Rails.logger.debug "****************************************"
    render :nothing => true
  end

  private

    def element_params
      params.permit(@template.fields.collect(&:name))
    end

end
