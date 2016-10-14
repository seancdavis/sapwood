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
#  processed   :boolean          default(FALSE)
#

class DocumentsController < ApplicationController

  before_filter :verify_property_access

  def index
    not_found if current_template.nil?
    @documents = if params[:f]
      if params[:f] == '0-9'
        current_property.elements.with_template(current_template.name)
          .starting_with_number.by_title.page(params[:page] || 1).per(12)
      else
        current_property.elements.with_template(current_template.name)
          .starting_with(params[:f]).by_title.page(params[:page] || 1).per(12)
      end
    else
      current_property.elements.with_template(current_template.name)
        .by_title.page(params[:page] || 1).per(12)
    end
    render :partial => 'list' if request.xhr?
  end

  def new
    render :layout => false
  end

  def create
    respond_to do |format|
      format.json { @document = Element.create!(create_params) }
    end
  end

  private

    def create_params
      params.require(:document).permit(:url)
            .merge(:property => current_property,
                   :template_name => current_template.name)
    end

end
