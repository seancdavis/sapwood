class ClearCache

  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  ensure
    Rails.cache.delete_matched(/\_p[\d]+\_(.*)/)
  end

end
