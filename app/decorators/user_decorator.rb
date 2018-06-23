# frozen_string_literal: true

module UserDecorator

  extend ActiveSupport::Concern

  included do
    def display_name
      name.blank? ? email : name
    end
  end

end
