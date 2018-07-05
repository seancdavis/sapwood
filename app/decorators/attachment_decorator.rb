# frozen_string_literal: true

module AttachmentDecorator

  extend ActiveSupport::Concern

  included do
    def formatted_date(attr = :created_at)
      send(attr).strftime('%b %d, %Y')
    end

    def uploaded_at
      formatted_date(:created_at)
    end

    def filename(ext = true)
      File.basename(url.to_s, ext ? '' : '.*')
    end

    def image?
      IMAGE_EXTENSIONS.include?(file_ext)
    end

    def file_ext
      File.extname(url.to_s).downcase.remove('.')
    end

    def url
      super.present? ? URI.parse(URI.encode(super)) : nil
    end

    def path
      url.try(:path)
    end
  end

end
