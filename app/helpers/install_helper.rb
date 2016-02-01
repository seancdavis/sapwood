module InstallHelper

  def install_card(options = {}, &block)
    content_tag(:div, :class => 'card') do
      o = content_tag(:div, :class => 'title') do
        o  = content_tag(:h1, options[:title])
        o += content_tag(:span, '', :class => 'progress',
                         :style => "width: #{install_progress * 100}%")
      end
      o += content_tag(:div, capture(&block), :class => 'content')
    end
  end

  def install_progress
    current_step.to_f / @total_steps.to_f
  end

end
