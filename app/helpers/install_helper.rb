module InstallHelper

  def install_card(options = {}, &block)
    content_tag(:div, :class => 'card') do
      o = content_tag(:div, :class => 'title') do
        o  = content_tag(:h1, options[:title])
        o += content_tag(:span, '', :class => 'progress',
                         :style => "width: '#{current_step / @total_steps}%'")
      end
      o += content_tag(:div, capture(&block), :class => 'content')
    end
  end

end
