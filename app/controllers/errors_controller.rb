# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_profile_completion

  def not_found
    render status: 404
  end

  def server_error
    render status: 500
  end

  def unacceptable
    render status: 422
  end
end
