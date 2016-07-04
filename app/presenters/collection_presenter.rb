class CollectionPresenter

  def initialize(obj)
    @obj = obj
  end

  def created_at
    @obj.created_at.strftime('%b %d, %Y')
  end

  def updated_at
    @obj.updated_at.strftime('%b %d, %Y')
  end

end
