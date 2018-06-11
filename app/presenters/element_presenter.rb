# frozen_string_literal: true

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
    File.extname(@obj.url.to_s).remove('.').downcase
  end

  def uploaded_at
    return nil unless @obj.document?
    @obj.created_at.strftime('%b %d, %Y')
  end
end
