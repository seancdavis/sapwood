class PropertyPresenter

  def initialize(obj)
    @obj = obj
  end

  def label_title(label)
    "#{@obj.title} #{@obj.label(label)}"
  end

  def label_new(label)
    "New #{@obj.label(label).singularize}"
  end

end
