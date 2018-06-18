# frozen_string_literal: true

module ImagesHelper

  def image_thumb_url(document)
    return image_url('document.png') unless document.public? && document.image?
    ix_image_url(document.path, auto: 'format,compress', w: 200, h: 200, fit: 'crop', sizes: '50px')
  end

end