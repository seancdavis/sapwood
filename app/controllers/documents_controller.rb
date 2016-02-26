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
#

class DocumentsController < ApplicationController

  def index
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

  private

    def document_params
      params.require(:document).permit(:title)
    end

    def create_params
      params.require(:document).permit(:url)
        .merge(:property => current_property)
    end

end
