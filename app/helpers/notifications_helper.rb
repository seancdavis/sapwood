module NotificationsHelper

  def notification_on?
    return false if current_template.blank? || current_property.blank?
    current_user.notifications.for_template(current_template)
                .in_property(current_property).present?
  end

  def notification_toggle_path(template)
    return nil if current_template.blank? || current_property.blank?
    property_notifications_path current_property,
                                :template => URI.encode(template),
                                :redirect_to => request.path
  end

end
