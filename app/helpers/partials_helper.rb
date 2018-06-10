# frozen_string_literal: true

module PartialsHelper
  def render_partial(name, options = {})
    render partial: "application/#{name}",
           locals: { options: options }
  end

  def page_header(options = {})
    render_partial('page_header', options)
  end

  def card(options = {}, &block)
    render_partial('card', options.merge(content: capture(&block)))
  end

  def svg(name)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return File.read(file_path).html_safe if File.exists?(file_path)
    '(not found)'
  end
end
