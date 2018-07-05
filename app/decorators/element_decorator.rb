# frozen_string_literal: true

module ElementDecorator

  extend ActiveSupport::Concern

  included do
    def formatted_date(attr = :created_at)
      send(attr).strftime('%b %d, %Y')
    end
  end

end
