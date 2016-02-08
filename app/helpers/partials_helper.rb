module PartialsHelper

  def page_header(options = {})
    render :partial => 'application/page_header',
           :locals => { :options => options }
  end

end
