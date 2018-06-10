class ElementPresenter

  def initialize(obj)
    @obj = obj
  end

  def created_at
    @obj.created_at.strftime('%b %d, %Y')
  end

  def updated_at
    @obj.updated_at.strftime('%b %d, %Y')
  end

  def file_type
    return nil unless @obj.document?
    @obj.url.split('.').last.downcase
  end

  def uploaded_at
    return nil unless @obj.document?
    @obj.created_at.strftime('%b %d, %Y')
  end

end
