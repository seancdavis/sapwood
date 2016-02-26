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

end
