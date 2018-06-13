module ElementDecorator

  extend ActiveSupport::Concern

  included do
    def formatted_date(attr = :created_at)
      send(attr).strftime('%b %d, %Y')
    end

    def uploaded_at
      document? ? formatted_date(:created_at) : nil
    end

    def file_type
      document? ? File.extname(url.to_s).remove('.').downcase : nil
    end
  end

end
