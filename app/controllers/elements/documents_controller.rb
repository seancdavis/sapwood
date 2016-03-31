class Elements::DocumentsController < ElementsController

  def new
    not_found unless request.xhr?
    render :layout => false
  end

  def create
    respond_to do |format|
      format.json { @document = Document.create!(document_params) }
    end
  end

  private

    def document_params
      params.require(:document).permit(:title, :url)
        .merge(:property => current_property)
    end

end
