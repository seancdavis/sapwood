class NotificationsController < ApplicationController

  before_action :verify_property_access

  def create
    not_found if params[:template].blank?
    template_name = URI.decode(params[:template])
    @current_template = current_property.find_template(template_name)
    not_found if current_template.blank?
    @notification = current_user.notifications.find_by(
      :template_name => current_template.name,
      :property => current_property
    )
    if @notification.nil?
      current_user.notifications.create(
        :template_name => current_template.name,
        :property => current_property
      )
      notice = "Notifications enabled for #{current_template.name}"
    else
      @notification.destroy
      notice = "Notifications disabled for #{current_template.name}."
    end
    redirect_to params[:redirect_to] || request.referrer || current_property,
                :notice => notice
  end

end
