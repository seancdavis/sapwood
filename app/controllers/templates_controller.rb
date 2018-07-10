# frozen_string_literal: true

class TemplatesController < ApplicationController

  before_action :verify_property_access

  def index
    template = current_property.templates.first
    redirect_to(template.blank? ? [current_property] : [current_property, template, :elements])
  end

end
