class UserPresenter

  def initialize(obj)
    @obj = obj
  end

  def name
    @obj.name.blank? ? @obj.email : @obj.name
  end

end
