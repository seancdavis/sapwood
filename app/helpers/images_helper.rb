# frozen_string_literal: true

module ImagesHelper

  def image_thumb_url(path)
    ix_image_url(path, auto: 'format,compress', w: 200, h: 200, fit: 'crop', sizes: '50px')
  end

end
