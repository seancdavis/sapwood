class ApplicationMailer < ActionMailer::Base

  default :from => Sapwood.config.default_from

  layout 'mailer'

  before_action :reload_sapwood

  private

    def reload_sapwood
      Sapwood.reload!
    end

end
