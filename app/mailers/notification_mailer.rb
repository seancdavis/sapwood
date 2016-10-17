class NotificationMailer < ApplicationMailer

  def notify(options = {})
    @notification = options[:notification]
    @user = @notification.user
    @element = options[:element]
    @template = options[:template]
    @property = options[:property]
    @subject = if options[:action_name] == 'create'
      "A new #{@template.name.downcase} was created in #{@property.title}"
    else
      "#{@template.name} #{@element.title} updated in #{@property.title}"
    end
    mail :to => @user.email, :from => Sapwood.config.default_from,
         :subject => @subject
  end

end
