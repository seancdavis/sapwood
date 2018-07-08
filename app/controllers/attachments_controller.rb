class AttachmentsController < ApplicationController

  before_action :verify_property_access
  before_action :verify_current_attachment, only: %i[edit update destroy]

  def index
    @attachments = current_property.attachments.by_title.page(params[:page] || 1).per(24)
    render partial: 'list' if request.xhr?
  end

  def search
    not_found unless params[:search] && params[:search][:q]
    @attachments = current_property.attachments
      .search_by_title(params[:search][:q]).page(params[:page] || 1).per(24)
    @page_title = 'Search Results'
    render 'index'
  end

  def new
    render layout: false
  end

  def create
    respond_to do |format|
      format.json do
        @attachment = current_property.attachments.create!(attachment_params)
      end
    end
  end

  def edit; end

  def update
    if current_attachment.update(attachment_params)
      redirect_to [current_property, :attachments], notice: 'Attachment updated successfully!'
    else
      render 'edit'
    end
  end

  def destroy
    current_attachment.destroy
    redirect_to [current_property, :attachments], notice: 'Attachment deleted successfully!'
  end

  private

    def attachment_params
      params.require(:attachment).permit(:title, :url)
    end

    def verify_current_attachment
      not_found if current_attachment.blank?
    end

end
