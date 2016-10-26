module ListHelper

  def list_sort_path(col)
    sort_by = col.field.name
    sort_in = 'asc'
    sort_in = 'desc' if params[:sort_by] == sort_by && params[:sort_in] == 'asc'
    property_template_elements_path(current_property, current_template,
                                    :sort_by => sort_by, :sort_in => sort_in)
  end

  def list_sort_class(col)
    return nil unless params[:sort_by] == col.field.name
    "active #{params[:sort_in] == 'asc' ? 'icon-arrow-up' : 'icon-arrow-down'}"
  end

end
