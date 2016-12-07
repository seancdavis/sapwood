class Api::V1::ElementsController < ApiController

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
        @elements = if params[:sort_by] || params[:order]
          @elements.by_field(params[:sort_by] || params[:order],
                             params[:sort_in]).with_associations
        else
          @elements.by_title.with_associations
        end
        render(:json => @elements.to_json(options))
      end
    end
  end

  def show
    respond_to do |f|
      f.json do
        @element = current_property.elements.where(:id => params[:id])
                                   .with_associations[0]
        not_found if @element.nil?
        options = params[:includes] ? { :includes => params[:includes] } : {}
        render(:json => @element.to_json(options))
      end
    end
  end

  def create
    @template = current_property.find_template(params[:template])
    forbidden if (
      @template.try(:security).try(:create).try(:allow).blank? ||
      @template.try(:security).try(:create).try(:secret) != params[:secret]
    )
    @element = Element.new(:template_data => element_params.to_hash)
    @element.property = current_property
    @element.template_name = @template.name
    if @element.save
      @element.send_notifications!(action_name)
      render :json => @element.to_json
    else
      render :json => @element.errors.messages
    end
  end

  def generate_url
    not_found unless params[:element_id] && params[:secret]
    @element = current_property.elements.find_by_id(params[:element_id])
    not_found if @element.blank?
    @template = @element.template
    not_found unless @template.private? &&
                     @template.security.try(:read).try(:secret).present? &&
                     params[:secret] == @template.security.read.secret
    url = GetDocumentUrl.call :document => @element,
                              :expires_in => params[:expires_in]
    render :text => url
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
