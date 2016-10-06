class DocumentPresenter

  def initialize(obj)
    @obj = obj
  end

  def file_type
    @obj.url.split('.').last.downcase
  end

  def uploaded_at
    @obj.created_at.strftime('%m.%d.%y')
  end

  def thumb_url(size = :small)
    return @obj.version(size, true) if @obj.image? && @obj.processed?
    h.image_path('document.png')
  end

  def thumb(size = :small)
    h.image_tag(thumb_url)
  end

  private

    def h
      ActionController::Base.helpers
    end

end
