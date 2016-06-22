# == Schema Information
#
# Table name: documents
#
#  id          :integer          not null, primary key
#  title       :string
#  url         :string
#  property_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  archived    :boolean          default(FALSE)
#

class DocumentsController < ApplicationController

  before_filter :verify_property_access

  def index
    render :partial => 'list' if request.xhr?
  end

  def new
    render :layout => false
  end

  def create
    respond_to do |format|
      format.json { @document = Document.create!(create_params) }
    end
  end

  def edit
  end

  def update
    if current_document.update(document_params)
      redirect_to property_documents_path(current_property),
                  :notice => "#{current_document.title} saved successfully!"
    else
      render 'edit'
    end
  end

  def destroy
    current_document.archive!
    redirect_to property_documents_path(current_property),
                :notice => "#{current_document.title} archived successfully!"
  end

  private

    def document_params
      params.require(:document).permit(:title)
    end

    def create_params
      params.require(:document).permit(:url)
        .merge(:property => current_property)
    end

end
