# frozen_string_literal: true

class DeckController < ApplicationController
  def show
    if !current_user.is_admin? && my_properties.size == 1
      redirect_to my_properties[0]
    end
  end
end
