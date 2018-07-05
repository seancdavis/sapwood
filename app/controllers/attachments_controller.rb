class AttachmentsController < ApplicationController

  before_action :verify_property_access

  def index
    @attachments = current_property.attachments
  end

  def create
    respond_to do |format|
      format.json do
        @attachment = current_property.attachments.create!(create_params)
      end
    end
  end

  private

    def create_params
      params.require(:attachment).permit(:url)
    end

end
