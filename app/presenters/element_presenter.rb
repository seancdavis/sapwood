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

  def thumb_url(size = :small)
    return nil unless @obj.document?
    return @obj.version(size, true) if @obj.image? && @obj.processed?
    h.image_path('document.png')
  end

  def thumb(size = :small)
    return nil unless @obj.document?
    h.image_tag(thumb_url)
  end

  private

    def h
      ActionController::Base.helpers
    end

end
