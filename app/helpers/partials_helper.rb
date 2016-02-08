module PartialsHelper

  def render_partial(name, options = {})
    render :partial => "application/#{name}",
           :locals => { :options => options }
  end

  def page_header(options = {})
    render_partial('page_header', options)
  end

  def card(options = {}, &block)
    render_partial('card', options.merge(:content => capture(&block)))
  end

end
