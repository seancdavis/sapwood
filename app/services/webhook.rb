# frozen_string_literal: true

require 'net/http'
require 'uri'

class Webhook

  def initialize(options = {})
    @options = options
    raise 'Missing option: element' unless options[:element]
  end

  def self.call(options = {})
    new(options).call
  end

  def call
    response = Net::HTTP.post_form(uri, form_data)
  end

  private

    def element
      @element ||= @options[:element]
    end

    def uri
      @uri ||= URI.parse(element.template.webhook_url)
    end

    def form_data
      @form_data ||= element.as_json.stringify_keys
    end

end
