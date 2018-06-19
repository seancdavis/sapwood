# frozen_string_literal: true

class Api::PropertiesController < ApiController

  def show
    respond_to do |f|
      f.json { render json: current_property }
    end
  end

end
